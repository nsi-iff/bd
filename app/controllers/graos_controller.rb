class GraosController < ApplicationController
  before_filter :carregar_grao, :if => :current_usuario

  def adicionar_a_cesta
    @cesta << params[:id]
    current_usuario.cesta << @grao if current_usuario.present?
    respond_to &:js
  end

  def remover_da_cesta
    @cesta.delete(params[:id])
    current_usuario.cesta.delete(@grao) if current_usuario.present?
    respond_to &:js
  end

  private

  def carregar_grao
    @grao = Grao.find(params[:id])
  end
end
