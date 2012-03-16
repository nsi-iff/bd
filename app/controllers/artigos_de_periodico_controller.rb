class ArtigosDePeriodicoController < InheritedResources::Base
  actions :new, :create, :show, :edit, :update, :aprovar

  include NovoComAutor
  include WorkflowActions
  include ContadorDeAcesso

  before_filter :authenticate_usuario!
  load_and_authorize_resource

  def create
    create! notice: 'Artigo de periodico submetido com sucesso'
  end

  def show
    incrementar_numero_de_acessos
  end
end
