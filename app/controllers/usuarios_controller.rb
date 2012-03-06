class UsuariosController < ApplicationController
  before_filter :authenticate_usuario!
  load_and_authorize_resource

  def index
    @usuarios = Usuario.all
  end

  def buscar
    @usuarios = Usuario.where('nome_completo like ?', "%#{params['buscar_nome']}%")
    render action: 'index'
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
end
