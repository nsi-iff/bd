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
end