# encoding: utf-8

class BuscasController < InheritedResources::Base
  actions :all, :except => [:index, :show]
  before_filter :authenticate_usuario!, except: [:index, :busca_avancada, :busca_normal, :resultado_busca]

  def index
    @tipos_conteudo = Conteudo.subclasses
    @areas = Area.all
    @sub_areas = SubArea.all
    @instituicoes = Instituicao.all
  end

  def busca_avancada
    @busca = Busca.new({busca: params[:busca], parametros: params[:parametros]})
    if @busca.parametros.empty?
      redirect_to buscas_path,
        :notice => "Busca não realizada. Favor preencher algum critério de busca"
    else
      @resultados = @busca.resultados
      render action: 'resultado_busca'
    end
  end

  def resultado_busca
  end

  def busca_normal
    @resultados = Conteudo.search(params[:busca])
    session[:ultima_busca] = params[:busca]
    render action: 'resultado_busca'
  end

  def create
    @busca = current_usuario.buscas.new(params[:busca].merge busca: session[:ultima_busca])
    create! notice: "Busca salva com sucesso"
  end

  def show
    busca = Busca.find(params[:id]).busca
    @conteudos = Conteudo.search(busca)
    render :resultado_busca
  end

  def cadastrar_mala_direta
    respond_to do |format|
      format.js do
        busca = Busca.find(params[:busca_id])
        busca.mala_direta = true
        busca.save
        redirect_to minhas_buscas_usuario_path(current_usuario),
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
        redirect_to minhas_buscas_usuario_path(current_usuario),
          :notice => 'Busca removida do servido de mala direta'
      end
    end
  end
end
