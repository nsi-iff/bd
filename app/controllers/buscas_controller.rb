class BuscasController < InheritedResources::Base
  actions :all, :except => [:index, :show]
  before_filter :authenticate_usuario!, except: [:index, :busca_avancada]

  def index
      @tipos_conteudo = [Relatorio, TrabalhoDeObtencaoDeGrau, ArtigoDePeriodico, ArtigoDeEvento,
                         Livro, ObjetoDeAprendizagem, PeriodicoTecnicoCientifico]
      @areas = Area.all
      @sub_areas = SubArea.all
      @instituicoes = Instituicao.all
  end

  def busca_avancada
    @conteudos = []
    if params[:busca]
      @conteudos = Conteudo.search params[:busca]
      session[:ultima_busca] = params[:busca]
    end
    render action: 'index'
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
        redirect_to usuario_minhas_buscas_path(current_usuario),
          :notice => 'Busca cadastrada no servico de mala direta'
      end
    end
  end

  def remover_mala_direta
    respond_to do |format|
      format.js do
        busca = Busca.find(params[:busca_id])
        busca.mala_direta = false
        busca.save
        redirect_to usuario_minhas_buscas_path(current_usuario),
          :notice => 'Busca removida do servido de mala direta'
      end
    end
  end
end
