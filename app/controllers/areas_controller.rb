class AreasController < ApplicationController
  def sub_areas
    @area = Area.where("nome = ? OR id = ?", params[:id], params[:id].to_i).first
    respond_to &:js
  end
end
