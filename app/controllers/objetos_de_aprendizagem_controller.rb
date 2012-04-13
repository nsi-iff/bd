class ObjetosDeAprendizagemController < InheritedResources::Base
  actions :new, :create, :show, :edit, :update, :aprovar, :submeter

  include NovoComAutor
  include WorkflowActions
  include ContadorDeAcesso
  include Favoritar
  include CallbackGranularizacao

  before_filter :authenticate_usuario!
  before_filter :pode_editar, only: [:edit, :update]
  load_and_authorize_resource

  def create
    @objeto_de_aprendizagem = ObjetoDeAprendizagem.new(params[:objeto_de_aprendizagem])
    @objeto_de_aprendizagem.cursos = []
    cursos_anteriores = []
    cont = 0
    lista_eixos_cursos = params['cursos_selecionados_oculto'].strip.split(' ,')
    lista_eixos_cursos.each do |descricao_curso|
      nome_eixo, nome_curso = descricao_curso.split(':  ')
      if cont != 0
        cursos = nome_curso.strip.split('  ')
        cursos_anteriores.each do |curso|
          if cursos.include? curso
            cursos.delete(curso)
          end
        end
        nome_curso = cursos[0]
      end
      eixo = EixoTematico.find_by_nome(nome_eixo)
      @objeto_de_aprendizagem.cursos << eixo.cursos.where(nome: nome_curso).first
      cursos_anteriores << nome_curso
      cont += 1;
    end
    if @objeto_de_aprendizagem.save
      redirect_to @objeto_de_aprendizagem
    else
      render :action => :new
    end
  end

  def show
    incrementar_numero_de_acessos
  end
end

