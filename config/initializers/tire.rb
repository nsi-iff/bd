Tire.configure do
  client Tire::Http::Client::MockClient
  logger "#{Rails.root}/log/elasticsearch.log"
end
