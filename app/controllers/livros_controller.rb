class LivrosController < InheritedResources::Base
  actions :new, :create, :show, :edit, :update, :submeter, :aprovar

  include NovoComAutor
  include WorkflowActions

  before_filter :authenticate_usuario!
  load_and_authorize_resource

  def create
    create! notice: 'Livro enviado com sucesso'
  end
end

