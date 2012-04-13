require 'net/http'
require 'json'

payload = {
  'doc_key' => @sam_uid,
  'grains_keys' => {
    'images' => 3.times.map {|n| rand.to_s.split('.').last },
    'files' => 2.times.map {|n| rand.to_s.split('.').last } }
}.to_json

req = Net::HTTP::Post.new('/artigos_de_evento/granularizou',
                          {'Content-Type' => 'application/json'})
req.body = payload
response = Net::HTTP.new('localhost', '3000').start {|http| http.request(req) }
puts "Response #{response.code} #{response.message}: #{response.body}"
