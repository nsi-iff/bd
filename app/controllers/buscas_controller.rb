class BuscasController < InheritedResources::Base
  belongs_to :usuario

  def create
    @usuario = current_usuario
    @busca = Busca.new(params[:busca].merge busca: session[:ultima_busca], usuario: @usuario)
    create! :notice => "Busca salva com sucesso"
  end

  def show
    busca = Busca.find(params[:id]).busca
    p busca
    @conteudos = Conteudo.search(busca)
    render 'busca/index'
  end
end