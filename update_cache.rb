require 'json'
require 'uri'
require 'net/http'

endpoint      = 'https://circleci.com/api/v1/projects?circle-token'
uri           = URI.parse("#{endpoint}=#{ENV['CIRCLECI_TOKEN']}")
https         = Net::HTTP.new(uri.host, uri.port)
https.use_ssl = true
req           = Net::HTTP::Get.new(uri.request_uri)
req['Accept'] = 'application/json'
res           = https.request(req)

if res.code == '200'
  File.write('/var/tmp/circleci.json', res.body)
  puts 'Success. Update CIrcleci Project URLs Cache.'
else
  puts "#{res.message}"
end
