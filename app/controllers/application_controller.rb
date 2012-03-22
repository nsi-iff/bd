# encoding: utf-8
class ApplicationController < ActionController::Base
  protect_from_forgery

  def pode_editar
    @conteudo = Conteudo.find(params[:id])
    unless (@conteudo.editavel? or @conteudo.publicado?) or current_usuario.gestor?
      redirect_to @conteudo, alert: 'Conteúdo não pode ser editado'
    end
  end
end
