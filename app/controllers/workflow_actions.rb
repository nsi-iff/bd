module WorkflowActions
  def submeter
    object = model_class.find(params[:"#{model_object_name}_id"])
    object.submeter
    redirect_to object
  end

  def aprovar
    object = model_class.find(params[:"#{model_object_name}_id"])
    object.aprovar
    redirect_to object
  end
end

