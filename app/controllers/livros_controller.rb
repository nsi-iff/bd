class LivrosController < InheritedResources::Base
  actions :new, :create, :show, :edit, :update, :submeter, :aprovar

  include NovoComAutor
  include WorkflowActions
  include ContadorDeAcesso
  include Favoritar

  before_filter :authenticate_usuario!
  before_filter :pode_editar, only: [:edit, :update]
  load_and_authorize_resource

  def create
    create! notice: 'Livro enviado com sucesso'
  end

  def show
    incrementar_numero_de_acessos
  end
end

