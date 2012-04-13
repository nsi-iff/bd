class ArtigosDeEventoController < InheritedResources::Base
  actions :new, :create, :show, :edit, :update, :aprovar, :submeter

  include NovoComAutor
  include WorkflowActions
  include ContadorDeAcesso
  include Favoritar
  include CallbackGranularizacao

  before_filter :authenticate_usuario!, except: :granularizou
  before_filter :pode_editar, only: [:edit, :update]
  load_and_authorize_resource except: :granularizou

  def create
    create! notice: 'Artigo de evento enviado com sucesso'
  end

  def show
    incrementar_numero_de_acessos
  end
end

