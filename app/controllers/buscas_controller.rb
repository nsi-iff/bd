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

  def cadastrar_mala_direta
    respond_to do |format|
      format.js do
        busca = Busca.find(params[:busca_id])
        busca.mala_direta = true
        busca.save
        redirect_to usuario_minhas_buscas_path(current_usuario), :notice => 'Busca cadastrada no servico de mala direta'
      end
    end

  end

  def remover_mala_direta
    respond_to do |format|
      format.js do
        busca = Busca.find(params[:busca_id])
        busca.mala_direta = false
        busca.save
        redirect_to usuario_minhas_buscas_path(current_usuario), :notice => 'Busca removida do servido de mala direta'
      end
    end
  end
end
