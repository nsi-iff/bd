  module ActiveRecord
  class Base
    private

    def object_collection_name
      self.class.name.underscore.pluralize
    end
  end
end
