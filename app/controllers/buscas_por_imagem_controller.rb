class BuscasPorImagemController < ApplicationController
  def new
  end
  
  def create
    if params['imagefile'].present?
      # TODO ainda falta implementar isto
      render 'new'
    else
      flash[:notice] = 'Favor incluir uma imagem antes de buscar.'
      render 'new'
    end
  end
end
