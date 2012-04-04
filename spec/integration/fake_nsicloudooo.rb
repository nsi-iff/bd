module NSICloudooo
  class Client
    class << self
      attr_accessor :image_grains, :file_grains
    end

    def initialize(url)
      @sam = NSISam::Client.new('anything')
    end

    def granulate(options)
      { 'doc_key' => random_key }
    end

    def done(key)
      { 'done' => true }
    end

    def grains_keys_for(doc_key)
      { 'images' => (self.class.image_grains || 0).times.map { random_key },
        'files'=> (self.class.file_grains || 0).times.map { random_key } }
    end

    private

    def random_key
      rand.to_s.split('.')[1]
    end
  end
end

