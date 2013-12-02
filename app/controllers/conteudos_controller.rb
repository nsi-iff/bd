# encoding: utf-8
require './lib/extrair_metadados.rb'

class ConteudosController < ApplicationController
  before_filter :authenticate_usuario!, except: [:granularizou, :show,
                :baixar_conteudo, :por_area, :por_sub_area]
  before_filter :pode_editar, only: [:edit, :update]

  def new
    authorize! :create, Conteudo
    @conteudo = klass.new
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
      if @conteudo.permite_extracao_de_metadados? and @conteudo.arquivo.present? and @conteudo.arquivo.extensao == "pdf"
        extrair_metadados(@conteudo)
        redirect_to root_path,
                  notice: "#{@conteudo.class.nome_humanizado} enviado com sucesso"
      else
        redirect_to conteudo_path(@conteudo),
                  notice: "#{@conteudo.class.nome_humanizado} enviado com sucesso"
      end
    else
      if @conteudo.arquivo && @conteudo.arquivo.errors['mime_type'].any?
        flash[:alert] = %Q[Arquivo com formato inválido,
                    favor reenviar o arquivo com o formato
                    convertido (Maiores informações podem
                    ser obtidas <a href="#{converter_video_path}">aqui</a>)]
      end
      @conteudo.build_arquivo
      render action: 'new'
    end
  end

  def edit
    @conteudo = obter_conteudo
    @conteudo.valid?
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

  def pre_submeter
    authorize! :submeter, Conteudo
    @conteudo = obter_conteudo
    redirect_to edit_conteudo_path(@conteudo) if !@conteudo.valid?
  end

  def submeter
    authorize! :submeter, Conteudo
    conteudo = obter_conteudo
    if conteudo.valid?
      conteudo.submeter
      redirect_to conteudo_path(conteudo)
    else
      redirect_to edit_conteudo_path(conteudo)
    end
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
    if params['doc_key']
      key = params['doc_key']
      type  = "doc"
      thumb = "thumbnail_key"
    elsif params['video_key']
      key = params['video_key']
      type = "video"
      thumb = "thumbnails_keys"
    end
    conteudo = Conteudo.encontrar_por_id_sam(key)
    conteudo.granularizou!(graos: params['grains_keys'], thumbnail: params[thumb], type: type)
    render nothing: true
  end

  def por_area
    area = Area.find(params[:area_id])
    @conteudos = area.conteudos[0..20].select{|x| x.estado== "publicado"}
  end

  def por_sub_area
    sub_area = SubArea.find(params[:sub_area_id])
    @conteudos = sub_area.conteudos[0..20].select{|x| x.estado== "publicado"}
  end

  def baixar_conteudo
    @conteudo = Conteudo.find(params[:conteudo_id])
    key = @conteudo.arquivo.key
    sam = ServiceRegistry.sam
    string64 = sam.get(key)
    arquivo = Base64.decode64(string64.data['file'])
    send_data arquivo.force_encoding('UTF-8'), type: @conteudo.arquivo.mime_type,
      filename: @conteudo.arquivo.nome
  end

  private

  def klass
    params['tipo'].camelize.constantize
  end

  def tipo_conteudo
    params['tipo'].try(:to_sym) || @conteudo.nome_como_simbolo
  end

  def conteudo_da_requisicao
    params.require(tipo_conteudo).permit(conteudo_attributes, conteudo_hash)
  end

  def conteudo_attributes
    [:contribuidor, :titulo, :link, :sub_area_id, :campus_id, :contribuidor_id,
     :subtitulo, :resumo, :direitos, :sub_area, :campus, :autores, :pronatec].
     concat(CONTEUDO_ATTRIBUTES_POR_TIPO[tipo_conteudo])
  end

  CONTEUDO_ATTRIBUTES_POR_TIPO = {
      'artigo_de_periodico' => [
        :nome_periodico, :editora, :fasciculo, :volume_publicacao,
        :data_publicacao_br, :local_publicacao, :pagina_inicial, :pagina_final],
      'artigo_de_evento' => [
        :subtitulo, :nome_evento, :numero_evento, :local_evento, :ano_evento,
        :local_publicacao, :titulo_anais, :pagina_inicial, :pagina_final,
        :editora, :resumo, :direitos],
      'livro' => [:traducao, :numero_edicao, :local_publicacao, :editora,
        :ano_publicacao, :numero_paginas],
      'objeto_de_aprendizagem' => [:palavras_chave, :tempo_aprendizagem,
        :novas_tags, :idioma_id],
      'periodico_tecnico_cientifico' => [:editora, :local_publicacao,
        :ano_primeiro_volume, :ano_ultimo_volume],
      'relatorio' => [:local_publicacao, :ano_publicacao, :numero_paginas],
      'trabalho_de_obtencao_de_grau' => [:numero_paginas, :instituicao,
        :grau_id, :data_defesa_br, :local_defesa]
    }.with_indifferent_access

  def conteudo_hash
    hash = {
      arquivo_attributes: [:uploaded_file],
      autores_attributes: [:nome, :lattes, :_destroy]
    }
    hash.merge!(curso_ids: []) if tipo_conteudo.to_sym == :objeto_de_aprendizagem
    hash.with_indifferent_access
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
