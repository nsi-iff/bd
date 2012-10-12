class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :carregar_cesta
  before_filter :definir_host_do_mailer

unless Rails.application.config.consider_all_requests_local
  rescue_from Exception, :with => :render_error
  rescue_from ActiveRecord::RecordNotFound, :with => :render_not_found
  rescue_from ActionController::RoutingError, :with => :render_not_found
  rescue_from ActionController::UnknownController, :with => :render_not_found
  rescue_from ActionController::UnknownAction, :with => :render_not_found
end

def render_not_found(exception)
  render :template => "/errors/404.html.erb", :layout => 'application'
end

def render_error(exception)
  ExceptionNotifier::Notifier.exception_notification(request.env, exception).deliver
  debugger
  render :template => "/errors/500.html.erb", :layout => 'application'
end

def routing_error
  render_not_found(nil)
end

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
