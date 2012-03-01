class ActionController::Base
  def current_user
    current_usuario
  end

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, :alert => 'Acesso negado'
  end
end

