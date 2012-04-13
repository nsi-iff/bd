require 'net/http'
require 'json'

module NSICloudooo
  class Client
    def initialize(url)
    end

    def granulate(options)
      { 'doc_key' => options[:sam_uid] }
    end
  end
end

