class UsuariosController < ApplicationController
  before_filter :authenticate_usuario!
  load_and_authorize_resource

  def index
  end

  def papeis
    @usuarios = Usuario.all
  end

  def buscar_por_nome
    @usuarios = Usuario.where('nome_completo like ?', "%#{params['buscar_nome']}%")
    render action: 'papeis'
  end

  def usuarios_instituicao
    @usuarios = Instituicao.where('nome like ?', Instituicao.find_by_id(params['usuarios_instituicao']).nome)
    .first.campus.map { |campus| campus.usuarios }.flatten
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
