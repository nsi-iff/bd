class AreasController < ApplicationController
  def sub_areas
    @area = Area.find_by_id(params[:id])
    respond_to &:js
  end
end
