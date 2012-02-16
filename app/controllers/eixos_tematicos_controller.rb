class EixosTematicosController < ApplicationController
  def cursos
    @eixo_tematico = EixoTematico.find_by_id(params[:id])
    respond_to do |format|
      format.js
    end
  end
end
