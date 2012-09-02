# encoding: utf-8

class ConteudosController < ApplicationController
  before_filter :authenticate_usuario!, except: [:granularizou, :show,
                :baixar_conteudo, :por_area, :por_sub_area]
  before_filter :pode_editar, only: [:edit, :update]

  def new
    authorize! :create, Conteudo
    @conteudo = klass.new
    @conteudo.build_arquivo
    @conteudo.pronatec = true if params['pronatec']
    @conteudo.autores << Autor.new
  end

  def create
    authorize! :create, Conteudo
    @conteudo = klass.new(conteudo_da_requisicao)
    if params['cursos_selecionados_oculto']
      @conteudo.cursos = params["cursos_selecionados_oculto"].
        split(',').
        map{|descricao_curso| descricao_curso.split(': ')}.
        map{|nome_eixo, nome_curso|
          EixoTematico.find_by_nome(nome_eixo).cursos.where(nome: nome_curso).first
        }
    end

    if @conteudo.save
      redirect_to conteudo_path(@conteudo),
                  notice: "#{@conteudo.class.nome_humanizado} enviado com sucesso"
    else
      @conteudo.build_arquivo
      render action: 'new'
    end
  end

  def edit
    @conteudo = obter_conteudo
    authorize! :update, @conteudo
  end

  def update
    authorize! :update, Conteudo
    @conteudo = obter_conteudo
    requisicao = conteudo_da_requisicao
    if params[:excluir_arquivo_atual]
      @conteudo.arquivo.destroy
      requisicao.delete :arquivo_attributes
    end

    if @conteudo.update_attributes(requisicao)
      redirect_to conteudo_path(@conteudo),
                  notice: "#{@conteudo.class.nome_humanizado} alterado com sucesso"
    else
      render action: 'edit'
    end
  end

  def show
    @conteudo = obter_conteudo
    unless @conteudo.publicado?
      authorize! :read, @conteudo
    end
    incrementar_numero_de_acessos
  end

  def destroy
    authorize! :destroy, Conteudo
    Conteudo.find(params[:id]).destroy
    redirect_to root_path
  end

  def recolher
    conteudo = obter_conteudo
    authorize! :recolher, conteudo
    conteudo.recolher
    redirect_to root_path
  end

  def submeter
    authorize! :submeter, Conteudo
    conteudo = obter_conteudo
    conteudo.submeter
    redirect_to conteudo_path(conteudo)
  end

  def aprovar
    conteudo = obter_conteudo
    authorize! :aprovar, conteudo
    conteudo.aprovar
    redirect_to conteudo_path(conteudo)
  end

  def devolver
    conteudo = obter_conteudo
    authorize! :devolver, conteudo
    conteudo.devolver
    redirect_to root_path
  end

  def recolher
    conteudo = obter_conteudo
    authorize! :recolher, conteudo
    conteudo.recolher
    redirect_to root_path
  end

  def favoritar
    authorize! :favoritar, Conteudo
    conteudo = obter_conteudo
    unless current_usuario.favorito? conteudo
      current_usuario.favoritar(conteudo.referencia)
    end
    redirect_to conteudo_path(conteudo)
  end

  def remover_favorito
    authorize! :remover_favorito, Conteudo
    conteudo = obter_conteudo
    current_usuario.remover_favorito(conteudo.referencia)
    redirect_to conteudo_path(conteudo)
  end

  def retornar_para_revisao
    authorize! :retornar_para_revisao, Conteudo
    conteudo = obter_conteudo
    conteudo.retornar_para_revisao
    redirect_to root_path
  end

  def granularizou
    conteudo = Conteudo.encontrar_por_id_sam(params['doc_key'])
    conteudo.granularizou!(graos: params['grains_keys'], thumbnail: params['thumbnail_key'])
    render nothing: true
  end

  def por_area
    area = Area.find(params[:area_id])
    @conteudos = area.conteudos[0..20]
  end

  def por_sub_area
    sub_area = SubArea.find(params[:sub_area_id])
    @conteudos = sub_area.conteudos[0..20]
  end

  def baixar_conteudo
    conteudo = Conteudo.find(params[:conteudo_id])
    @sam = ServiceRegistry.sam
    string = @sam.get(conteudo.arquivo.key).data['file']
    extensao = conteudo.extensao
    file = "#{Rails.root}/tmp/#{conteudo.titulo}.#{extensao}"
    File.open(file, "wb").write(Base64.decode64(string))
    send_file file
  end

  private

  def klass
    params['tipo'].camelize.constantize
  end

  def conteudo_da_requisicao
    params[params['tipo'].try(:to_sym) || @conteudo.nome_como_simbolo]
  end

  def obter_conteudo
    Conteudo.find(params[:id])
  end

  def incrementar_numero_de_acessos
    # TODO: mover para o model
    if @conteudo.publicado?
      @conteudo.numero_de_acessos += 1
      @conteudo.save!
    end
  end

  def pode_editar
    @conteudo = Conteudo.find(params[:id])
    unless (@conteudo.editavel? or @conteudo.publicado?) or current_usuario.gestor?
      redirect_to conteudo_path(@conteudo), alert: 'Conteúdo não pode ser editado'
    end
  end
end
