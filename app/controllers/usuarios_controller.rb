class UsuariosController < ApplicationController
  before_filter :authenticate_usuario!
  load_and_authorize_resource

  def index
  end

  def papeis
    @usuarios = current_usuario.usuarios_gerenciaveis
  end

  def buscar_por_nome
    @usuarios = Usuario.buscar_por_nome(params[:buscar_nome], current_usuario)
    render action: 'papeis'
  end

  def usuarios_instituicao
    @usuarios = Instituicao.find_by_id(params['usuarios_instituicao']).usuarios
    render action: 'papeis'
  end

  def atualizar_papeis
    params[:papeis] ||= {}
    Usuario.includes(:papeis).all.each do |usuario|
      usuario.update_attributes papel_ids: params[:papeis]["#{usuario.id}"] || []
    end
    redirect_to action: 'index'
  end

  def area_privada
  end

  def escrivaninha
    @conteudos = Conteudo.editaveis(current_usuario)
  end

  def lista_de_revisao
    @conteudos = []
    Conteudo.all.map { |conteudo| @conteudos << conteudo if conteudo.pendente? }
  end

  def minhas_buscas
  end
end
