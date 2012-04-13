module ActionController
  class Base
    private

    def model_class
      self.class.name.sub('Controller', '').singularize.constantize
    end

    def model_object_name
      self.class.name.sub('Controller', '').singularize.underscore
    end
  end
end


module ActiveRecord
  class Base
    private

    def object_collection_name
      self.class.name.underscore.pluralize
    end
  end
end
