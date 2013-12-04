#encoding: utf-8

class RegistrationsController < Devise::RegistrationsController
  before_filter :configure_permitted_params

  def edit
    @user = current_user
  end

  def update
    @user = current_user
    campus = Campus.find(params['campus'].to_i)
    unless @user.campus == campus
       @user.trocar_campus(campus)
       flash.now[:notice] = 'Suas alterações foram salvas com sucesso'
     end
    render :edit
  end

  private

  def configure_permitted_params
    devise_parameter_sanitizer.for(:sign_up).concat(
      [:nome_completo, :campus_id])
  end
end