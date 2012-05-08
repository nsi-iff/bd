module NSISam
  class FakeClient
    def initialize(params = {})
      @storage = {}
    end

    # Store a given data in SAM
    #
    # @param [String] data the desired data to store
    # @return [Hash] response with the data key and checksum
    #   * "key" [String] the key to access the stored data
    #   * "checksum" [String] the sha1 checksum of the stored data
    # @example
    #   nsisam.store("something")
    def store(data)
      key = Time.now.to_i
      @storage[key] = data
      {'key' => key, 'checksum' => 0 }
    end

    # Delete data at a given SAM key
    #
    # @param [Sring] key of the value to delete
    # @return [Hash] response
    #   * "deleted" [Boolean] true if the key was successfully deleted
    # @raise [NSISam::Errors::Client::KeyNotFoundError] When the key doesn't exists
    # @example Deleting an existing key
    #   nsisam.delete("some key")
    def delete(key)
      @storage.delete(key)
      true
    end

    def get(key)
      {'data' => @storage[key] }
    end

    # Update data stored at a given SAM key
    #
    # @param [String] key of the data to update
    # @param [String, Hash, Array] data to be stored at the key
    # @return [Hash] response
    #   * "key" [String] just to value key again
    #   * "checksum" [String] the new sha1 checksum of the key's data
    # @raise [NSISam::Errors::Client::KeyNotFoundError] When the key doesn't exists
    # @example
    #   nsisam.update("my key", "my value")
    def update(key, value)
      @storage[key] = value
      { 'key' => key, 'checksum' => 0 }
    end
  end
end