class ArtigosDePeriodicoController < InheritedResources::Base
  actions :new, :create, :show, :edit, :update, :aprovar

  include NovoComAutor

  before_filter :authenticate_usuario!
  load_and_authorize_resource

  def create
    create! notice: 'Artigo de periodico submetido com sucesso'
  end

  def aprovar
    artigo = ArtigoDePeriodico.find(params[:artigo_de_periodico_id])
    artigo.aprovar
    redirect_to artigo_de_periodico_path(artigo)
  end
end
