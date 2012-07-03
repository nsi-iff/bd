# encoding: utf-8

class BuscasController < InheritedResources::Base
  actions :all, :except => [:index, :show]
  before_filter :authenticate_usuario!, except: [:index, :busca_avancada, :busca_normal, :busca_por_imagem,
                                                 :busca_pronatec, :buscar_pronatec, :resultado_busca]

  respond_to :js, :only => [:cadastrar_mala_direta, :remover_mala_direta]

  def index
    @tipos_conteudo = Conteudo.subclasses
    @areas = Area.all
    @sub_areas = SubArea.all
    @instituicoes = Instituicao.all
  end

  def busca_avancada
    @busca = Busca.new(busca: params[:busca], parametros: params[:parametros])
    if !@busca.busca? && @busca.parametros.empty?
      redirect_to buscas_path,
        :notice => "Busca não realizada. Favor preencher algum critério de busca"
    else
      @resultados = @busca.resultados(:pronatec => true)
      render :resultado_busca
    end
  end

  def busca_avancada
    @busca = Busca.new(busca: params[:busca], parametros: params[:parametros])
    if !@busca.busca? && @busca.parametros.empty?
      redirect_to buscas_path,
        :notice => "Busca não realizada. Favor preencher algum critério de busca"
    else
      if @busca.parametros['tipos']
        @resultados = []
        @tipos = @busca.parametros['tipos']
        if @tipos.count("objeto_de_aprendizagem") == 1
          if "pronatec".in? @tipos
            @busca.resultados.map{|conteudo| @resultados << conteudo if conteudo.pronatec == true}
          else
            @busca.resultados.map{|conteudo| @resultados << conteudo if conteudo.pronatec != true and conteudo.class.name != "ObjetoDeAprendizagem"}
          end
          @busca.resultados.map{|conteudo| @resultados << conteudo if conteudo.class.name != "ObjetoDeAprendizagem"}
        else
          @resultados = @busca.resultados
        end
      else
        @resultados = @busca.resultados
      end
      render :resultado_busca
    end
  end

  def busca_pronatec
  end

  def buscar_pronatec
    @resultados = Conteudo.where('pronatec = ?', true).where('titulo = ?', params[:busca])
    #TODO: usar implementação seguinte quando busca avançada voltar a funcionar corretamente
    #@busca = Busca.new(busca: params[:busca], parametros: { pronatec: true })
    #@resultados = @busca.resultados
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
    @busca = current_usuario.buscas.new(params[:busca].merge busca: session[:ultima_busca])
    create! notice: "Busca salva com sucesso"
  end

  def show
    busca = Busca.find(params[:id]).busca
    @conteudos = Conteudo.search(busca)
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
end
