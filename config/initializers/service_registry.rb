class ServiceRegistry
  def self.sam=(sam)
    @sam = sam
  end

  def self.sam
    @sam ||= NSISam::Client.new(Rails.application.config.sam_configuration)
  end

  def self.cloudooo=(cloudooo)
    @cloudooo = cloudooo
  end

  def self.cloudooo
    @cloudooo ||= NSICloudooo::Client.new(Rails.application.config.cloudooo_configuration)
  end

  def self.videogranulate=(videogranulate)
    @videogranulate = videogranulate
  end

  def self.videogranulate
    @videogranulate ||= NSIVideoGranulate::Client.new(Rails.application.config.videogranulate_configuration)
  end
end

module ActiveRecord
  class Base
    def sam
      ServiceRegistry.sam
    end

    def cloudooo
      ServiceRegistry.cloudooo
    end

    def videogranulate
      ServiceRegistry.videogranulate
    end
  end
end
