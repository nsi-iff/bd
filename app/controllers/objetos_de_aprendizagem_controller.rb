class ObjetosDeAprendizagemController < InheritedResources::Base
  actions :new, :create, :show

  include NovoComAutor

  before_filter :authenticate_usuario!
  load_and_authorize_resource
end
