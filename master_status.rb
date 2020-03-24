require 'json'
require 'uri'
require 'net/http'

thequery = ARGV[0]

endpoint      = 'https://circleci.com/api/v1/projects?circle-token'
uri           = URI.parse("#{endpoint}=#{ENV['CIRCLECI_TOKEN']}")
https         = Net::HTTP.new(uri.host, uri.port)
https.use_ssl = true
req           = Net::HTTP::Get.new(uri.request_uri)
req['Accept'] = 'application/json'
res           = https.request(req)
result        = JSON.parse(res.body)

projects = {}

result.each do |k|

  branch = k['branches']['master'] ? 'master' : 'develop'
  repo = "#{k['username']}/#{k['reponame']}"

  vcs = k['vcs_type'] == 'bitbucket' ? "bb" : "gh"

  if k['branches'][branch]
    status = "#{k['branches'][branch]['recent_builds'][0]['status']}"
    projects["#{repo}"] = {
      url:    "https://circleci.com/#{vcs}/#{repo}",
      status: "#{status}"
    }
  end
end

xmlstring = "<?xml version=\"1.0\"?>\n<items>\n"

projects.each_with_index do |(k, v), i|
  if k.match(%r{[^\/]*#{thequery}[^\/]*$}i)
    if v[:status] =~ /success|fixed/
      icon = 'green.png'
    else
      icon = 'red.png'
    end
  thisxmlstring = "\t<item uid=\"#{i}\" autocomplete=\"#{k}\" arg=\"#{v[:url]}\" valid=\"YES\">
    <title>#{k}</title>
    <subtitle>#{v[:url]}</subtitle>
    <icon>#{icon}</icon>
    </item>\n"
  xmlstring += thisxmlstring
  else
    next
  end
end

xmlstring += '</items>'

puts xmlstring
