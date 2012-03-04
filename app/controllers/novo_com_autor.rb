module NovoComAutor
  def new
    object = model_class.new
    object.autores << Autor.new
    attr_name = "@#{model_object_name}"
    instance_variable_set(:"@#{model_object_name}", object)
  end

  private

  def model_class
    self.class.name.sub('Controller', '').singularize.constantize
  end

  def model_object_name
    self.class.name.sub('Controller', '').singularize.underscore
  end
end
