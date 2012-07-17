# encoding: UTF-8

class EditorController < ApplicationController
  def index
    @inclui_graos = params['graos']
  end

  def download
    send_file("#{view_context.criar_documento}", :filename => 'documento.html',
    :type => 'text/html', :disposition => 'attachment')
  end
end
