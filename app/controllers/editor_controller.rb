# encoding: UTF-8

class EditorController < ApplicationController
  def index
    @inclui_graos = params['graos']
  end

  def download
    graos = params['graos'].keys[0].to_sym
    documento = File.new("#{Rails.root}/tmp/documento.html", 'w')
    documento.write(params[:documento])
    if graos == :true
      documento.write("<b>")
      documento.write("REFERÊNCIAS".to_xs)
      documento.write("</b>")
      2.times{ documento.write("<br>") }
      current_usuario.cesta.each do |grao|
        conteudo_do_grao = Conteudo.find(grao.conteudo_id)
        documento.write(conteudo_do_grao.referencia_abnt)
        documento.write("<br>")
      end
    end
    documento.close()
    send_file("#{Rails.root}/tmp/documento.html", :filename => 'documento.html',
    :type => 'text/html', :disposition => 'attachment')
  end
end

