class ArtigosDeEventoController < InheritedResources::Base
  actions :new, :create, :show, :edit, :update, :aprovar

  include NovoComAutor

  before_filter :authenticate_usuario!
  load_and_authorize_resource

  def create
    create! notice: 'Artigo de evento submetido com sucesso'
  end

  def aprovar
    artigo = ArtigoDeEvento.find(params[:artigo_de_evento_id])
    artigo.aprovar
    redirect_to artigo_de_evento_path(artigo)
  end
end
