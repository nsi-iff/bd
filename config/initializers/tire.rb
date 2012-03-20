Tire.configure do
  client Tire::Http::Client::MockClient unless ENV['INTEGRACAO']
  logger "#{Rails.root}/log/elasticsearch.log"
end
