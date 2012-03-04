class UsuariosController < ApplicationController
  def index
    @usuarios = Usuario.all
    @papeis = Papel.all
  end

  def atualizar_papeis
    params[:papeis] ||= {}
    Usuario.all.each do |usuario|
      usuario.update_attributes papel_ids: params[:papeis]["#{usuario.id}"] || []
    end
    redirect_to action: 'index'
  end
end