class BuscasController < InheritedResources::Base
  actions :all, :except => [:index, :show]
  before_filter :authenticate_usuario!, except: [:index]

  def index
    @conteudos = []
    if params[:busca]
      @conteudos = Conteudo.search params[:busca]
      session[:ultima_busca] = params[:busca]
    end
  end

  def create
    @busca = current_usuario.buscas.new(params[:busca].merge busca: session[:ultima_busca])
    create! notice: "Busca salva com sucesso"
  end

  def show
    busca = Busca.find(params[:id]).busca
    @conteudos = Conteudo.search(busca)
    render :index
  end
end
