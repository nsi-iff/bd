# encoding: utf-8

class BuscasController < InheritedResources::Base
  actions :all, :except => [:index, :show]
  before_filter :authenticate_usuario!, except: [:index, :busca_avancada, :busca_normal, :busca_por_imagem,
                                                 :busca_pronatec, :buscar_pronatec, :resultado_busca]

  before_filter :tratar_dados_da_busca, only: [:busca_normal]
  respond_to :js, :only => [:cadastrar_mala_direta, :remover_mala_direta]

  def index
    @tipos_conteudo = Conteudo.subclasses
    @areas = Area.all
    @sub_areas = SubArea.all
    @instituicoes = Instituicao.all
    @usuario = current_usuario
  end

  def busca_avancada
    @busca = Busca.new(busca: params[:busca], parametros: params[:parametros])
    if !@busca.busca? && @busca.parametros.empty?
      redirect_to buscas_path,
        :notice => "Busca não realizada. Favor preencher algum critério de busca"
    else
      @resultados = Busca.filtrar_busca_avancada(@busca, current_usuario)
      render :resultado_busca
    end
  end

  def busca_pronatec
  end

  def buscar_pronatec
    @resultados = Busca.new(busca: params[:busca],
      parametros: { pronatec: true }).resultados
    render :resultado_busca
  end

  def resultado_busca
  end

  def busca_normal
    @resultados = Conteudo.search(params[:busca])
    session[:ultima_busca] = params[:busca]
    render :resultado_busca
  end

  def create
    params[:busca].merge! busca: session[:ultima_busca]
    @busca = current_usuario.buscas.new(params_busca)
    create! notice: "Busca salva com sucesso"
  end

  def update
    @busca = Busca.find(params[:id])
    if @busca.update_attributes(params_busca)
      redirect_to @busca
    else
      render 'edit'
    end
  end

  def show
    busca = Busca.find(params[:id]).busca
    @resultados = Conteudo.search(busca)
    render :resultado_busca
  end

  def cadastrar_mala_direta
    @busca = Busca.find(params[:busca_id])
    @busca.mala_direta = true
    @busca.save
    render :template => 'buscas/mala_direta'
  end

  def remover_mala_direta
    @busca = Busca.find(params[:busca_id])
    @busca.mala_direta = false
    @busca.save
    render :template => 'buscas/mala_direta'
  end

  def busca_por_imagem
  end

  def mala_direta
    @buscas = current_usuario.buscas
  end

  private

  def tratar_dados_da_busca
    params[:busca].gsub!('/', '\\/')
  end

  def params_busca
    params.require(:busca).permit(:parametros, :busca, :titulo, :descricao)
  end
end
