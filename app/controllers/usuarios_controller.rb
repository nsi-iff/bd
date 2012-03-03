class UsuariosController < ApplicationController
  def index
    @usuarios = Usuario.all
    @papeis = Papel.all
  end

  def atualizar_papeis
    # TODO: REFATORAR!!!
    Usuario.all.map(&:id).each { |id| params[:usuarios][id.to_s] = {papel_ids: []} unless params[:usuarios][id.to_s] }
    params[:usuarios].keys.each do |id|
      Usuario.find(id).update_attributes params[:usuarios][id]
    end
    redirect_to action: 'index'
  end
end
