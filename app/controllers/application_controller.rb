class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :carregar_cesta

  private

  def carregar_cesta
    @cesta = current_usuario.present? ?
      current_usuario.cesta_ids.map(&:to_s) :
      (session[:cesta] ||= [])
  end
end
