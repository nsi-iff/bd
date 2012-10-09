class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :carregar_cesta
  before_filter :definir_host_do_mailer

  private

  def definir_host_do_mailer
    ActionMailer::Base.default_url_options[:host] = request.host_with_port
  end

  def carregar_cesta
    @cesta = current_usuario.present? ?
      current_usuario.cesta_ids :
      (session[:cesta] ||= [])
  end
end
