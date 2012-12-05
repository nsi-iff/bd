
class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :carregar_cesta
  before_filter :definir_host_do_mailer

  unless Rails.application.config.consider_all_requests_local
    rescue_from Exception, :with => :render_error
  end

  def render_error(exception)
    if exceptions_404.include? exception.class
      log_exception(exception)
      render :template => "/errors/404", layout: 'application'
    else
      log_exception(exception)
      ExceptionNotifier::Notifier.exception_notification(request.env, exception)
      render :template => "/errors/500", layout: 'application'
    end
  end

  def routing_error
    raise ActionController::RoutingError.new(params[:path])
  end

  private

  def exceptions_404
    [ActionController::RoutingError, ActiveRecord::RecordNotFound,
     ActionController::UnknownController, ::AbstractController::ActionNotFound]
  end

  def log_exception(ex)
    Rails.logger.error "#{ex.class}: #{ex.message}\n  #{ex.backtrace.join("\n  ")}"
  end

  def definir_host_do_mailer
    ActionMailer::Base.default_url_options[:host] = request.host_with_port
  end

  def carregar_cesta
    @cesta = current_usuario.present? ?
      current_usuario.cesta_ids :
      (session[:cesta] ||= [])
  end
end
