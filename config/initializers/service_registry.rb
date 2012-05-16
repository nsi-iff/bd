require "nsisam"

class ServiceRegistry
  def self.sam=(sam)
    @sam = sam
  end

  def self.sam
    @sam ||= NSISam::Client.new(Rails.application.config.sam_configuration)
  end
end

module ActiveRecord
  class Base
    def sam
      ServiceRegistry.sam
    end
  end
end
