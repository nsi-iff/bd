class TrabalhosDeObtencaoDeGrauController < InheritedResources::Base
  actions :new, :create, :show

  before_filter :authenticate_usuario!
  load_and_authorize_resource

  def create
    create! notice: 'Trabalho de obtencao de grau submetido com sucesso'
  end
end

