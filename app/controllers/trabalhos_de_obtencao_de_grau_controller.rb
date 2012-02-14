class TrabalhosDeObtencaoDeGrauController < InheritedResources::Base
  actions :new, :create, :show

  def create
    create! notice: 'Trabalho de obtencao de grau submetido com sucesso'
  end
end
