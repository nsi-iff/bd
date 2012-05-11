class InstituicoesController < ApplicationController
  def campus
    @instituicao = Instituicao.find_by_id(params[:id])
    respond_to &:js
  end
end
