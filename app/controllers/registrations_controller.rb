#encoding: utf-8

class RegistrationsController < Devise::RegistrationsController
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

  def sign_up_params
    devise_parameter_sanitizer.for(:sign_up).merge \
      nome_completo: params[:usuario][:nome_completo],
      campus_id: params[:usuario][:campus_id]
  end
end