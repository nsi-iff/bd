class RelatoriosController < InheritedResources::Base
  actions :new, :create, :show, :edit, :update

  include NovoComAutor

  before_filter :authenticate_usuario!
  load_and_authorize_resource
end
