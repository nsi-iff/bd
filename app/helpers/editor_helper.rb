module EditorHelper
  def criar_documento
    graos = params['graos'].keys[0].to_sym
    documento = File.new("#{Rails.root}/tmp/documento.html", 'w')
    documento.write(params[:documento])
    if graos == :true
      documento.write("<b>REFER&Ecirc;NCIAS</b>")
      2.times{ documento.write("<br>") }
      current_usuario.cesta.map(&:referenciavel).each do |grao|
        conteudo_do_grao = Conteudo.find(grao.conteudo_id)
        documento.write(conteudo_do_grao.referencia_abnt)
        documento.write("<br>")
      end
    end
    documento.close()
    documento.path
  end
end
