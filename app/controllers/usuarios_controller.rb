class UsuariosController < ApplicationController
  before_filter :authenticate_usuario!
  load_and_authorize_resource

  def index
  end

  def papeis
    if current_usuario.admin?
      @usuarios = Usuario.all
    else
      @usuarios = current_usuario.campus.instituicao.campus.map { |campus| campus.usuarios }.flatten
    end
  end

  def buscar_por_nome
    @usuarios = []
    if current_usuario.admin?
      @usuarios = Usuario.where('nome_completo like ?', "%#{params['buscar_nome']}%")
    else
      usuarios = current_usuario.campus.instituicao.campus.map { |campus| campus.usuarios }.flatten
      usuarios.map {|usuario| @usuarios << usuario if params['buscar_nome'].in? usuario.nome_completo }
    end
    render action: 'papeis'
  end

  def usuarios_instituicao
    @usuarios = Instituicao.find_by_id(params['usuarios_instituicao']).campus.map { |campus| campus.usuarios }.flatten
    render action: 'papeis'
  end

  def atualizar_papeis
    params[:papeis] ||= {}
    Usuario.all.each do |usuario|
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
