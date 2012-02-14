require 'sinatra'
require 'json'

get '/' do
  content_type :json
  { metadata: 'something',
    data: "the thing you've requested using #{params[:key].inspect}" }.to_json
end

put '/' do
  content_type :json
  { key: 'a key to your uploaded content' }.to_json
end
