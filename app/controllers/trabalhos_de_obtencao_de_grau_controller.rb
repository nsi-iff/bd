class TrabalhosDeObtencaoDeGrauController < InheritedResources::Base
  actions :new, :create, :show, :edit, :update, :aprovar

  include NovoComAutor

  before_filter :authenticate_usuario!
  load_and_authorize_resource

  def create
    create! notice: 'Trabalho de obtencao de grau submetido com sucesso'
  end

  def aprovar
    trabalho = TrabalhoDeObtencaoDeGrau.find(params[:trabalho_de_obtencao_de_grau_id])
    trabalho.aprovar
    redirect_to trabalho_de_obtencao_de_grau_path(trabalho)
  end
end
