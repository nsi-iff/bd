class TrabalhosDeObtencaoDeGrauController < InheritedResources::Base
  actions :new, :create, :show

  include NovoComAutor

  before_filter :authenticate_usuario!
  load_and_authorize_resource

  def create
    create! notice: 'Trabalho de obtencao de grau submetido com sucesso'
  end
end
