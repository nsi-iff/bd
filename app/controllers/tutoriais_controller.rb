class TutoriaisController < ApplicationController
  def show
    arquivo_da_view = pagina_tutorial(params[:tutorial]) + ".*"
    if Dir.glob(arquivo_da_view).present?
      render pagina_tutorial(params[:tutorial]) and return
    end
    render 'public/404', layout: false, status: '404'
  end

  private

  def pagina_tutorial(tutorial_path)
    "#{Rails.root}/app/views/tutoriais/#{tutorial_path}"
  end
end