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

pipelines = {}

result.each do |k|
  project_slug = "#{k['vcs_type']}/#{k['username']}/#{k['reponame']}"
  pipelines["#{project_slug}"] = {
    url:    "https://app.circleci.com/pipelines/#{project_slug}"
  }
end

xmlstring = "<?xml version=\"1.0\"?>\n<items>\n"

pipelines.each_with_index do |(k, v), i|
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
