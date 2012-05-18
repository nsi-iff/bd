# encoding: UTF-8

class EditorController < ApplicationController
  def index
    @inclui_graos = params['graos']
  end

  def download
    documento = File.new("#{Rails.root}/tmp/documento.html", 'w')
    documento.write(params[:documento])
    documento.close
    send_file("#{Rails.root}/tmp/documento.html", :filename => 'documento.html',
    :type => 'text/html', :disposition => 'attachment')
  end
end
