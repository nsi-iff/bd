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
    # XXX: Use TIRE (this is a really ugly solution)
    area = params[:area] || nil
    area != 'Todas' || area = nil
    sub_area = params[:sub_area] || nil
    sub_area != 'Todas' || sub_area = nil
    instituicao = params[:instituicao] || nil
    instituicao != 'Todas' || instituicao = nil
    tipo_conteudo = params[:tipo_conteudo] || nil
    titulo = params[:titulo] || nil
    autor = params[:autor] || nil

    conteudos = Conteudo.scoped
    #conteudos = conteudos.where('area_id = ?', area) if area
    conteudos = conteudos.where('sub_area_id = ?', sub_area) if sub_area
    #conteudos = conteudos.where('instituicao_id = ?', instituicao) if instituicao
    conteudos = conteudos.where('type = ?', tipo_conteudo) if tipo_conteudo
    conteudos = conteudos.where('titulo = ?', titulo) if titulo
    #conteudos = conteudos.where('autor = ?', autor) if autor

    @conteudos = conteudos
    session[:ultima_busca] = params
    render action: 'resultado_busca'
  end

  def resultado_busca
  end

  def busca_normal
    @conteudos = Conteudo.search params[:busca]
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
