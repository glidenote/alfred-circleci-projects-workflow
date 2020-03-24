require 'json'

thequery  = ARGV[0]
json_file = '/var/tmp/circleci.json'

begin
  result = open(json_file) do |io|
    JSON.load(io)
  end
rescue
  puts "#{json_file} not found."
  exit
end

projects = {}

result.each do |k|
  repo = "#{k['username']}/#{k['reponame']}"

  vcs = k['vcs_type'] == 'bitbucket' ? "bb" : "gh"

  projects["#{repo}"] = {
    url:    "https://circleci.com/#{vcs}/#{repo}"
  }
end

xmlstring = "<?xml version=\"1.0\"?>\n<items>\n"

projects.each_with_index do |(k, v), i|
  if k.match(%r{[^\/]*#{thequery}[^\/]*$}i)
    thisxmlstring = "\t<item uid=\"#{i}\" autocomplete=\"#{k}\" arg=\"#{v[:url]}\" valid=\"YES\">
    <title>#{k}</title>
    <subtitle>#{v[:url]}</subtitle>
    </item>\n"
    xmlstring += thisxmlstring
  else
    next
  end
end

xmlstring += '</items>'

puts xmlstring
