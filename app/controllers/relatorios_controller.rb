class RelatoriosController < InheritedResources::Base
  actions :new, :create, :show, :edit, :update, :aprovar

  include NovoComAutor

  before_filter :authenticate_usuario!
  load_and_authorize_resource

  def aprovar
    relatorio = Relatorio.find(params[:relatorio_id])
    relatorio.aprovar
    redirect_to relatorio_path(relatorio)
  end
end
