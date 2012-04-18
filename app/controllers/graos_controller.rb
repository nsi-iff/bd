class GraosController < ApplicationController
  def adicionar_a_cesta
    session[:cesta] ||= []
    session[:cesta] << params[:id]
    respond_to &:js
  end

  def remover_da_cesta
    session[:cesta] ||= []
    session[:cesta].delete(params[:id])
    respond_to &:js
  end
end
