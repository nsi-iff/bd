class EixosTematicosController < ApplicationController
  def cursos
    @eixo_tematico = EixoTematico.find_by_id(params[:id])
    respond_to &:js
  end
end
