class BuscasController < InheritedResources::Base
  belongs_to :usuario

  def index
    if params[:busca]
      @conteudos = Conteudo.search params[:busca]
      session[:ultima_busca] = params[:busca]
    else
      @conteudos = []
    end
  end

  def create
    @usuario = current_usuario
    @busca = Busca.new(params[:busca].merge busca: session[:ultima_busca], usuario: @usuario)
    create! :notice => "Busca salva com sucesso"
  end

  def show
    busca = Busca.find(params[:id]).busca
    p busca
    @conteudos = Conteudo.search(busca)
    render 'index'
  end
end
