Tire.configure do
  client Tire::Http::Client::MockClient
  logger 'log/elasticsearch.log'
end
