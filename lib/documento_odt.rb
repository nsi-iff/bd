require 'fileutils'
require 'nokogiri'
require 'rubygems'

include REXML
include Zip

class DocumentoOdt
  def initialize(nome)
    template_modelo = "#{Rails.root}/public/template.odt"
    @arquivo = File.join("#{Rails.root}/tmp/#{nome}.odt")
    FileUtils.cp(template_modelo, @arquivo)
    @arquivo_odt = Zip::ZipFile.open(@arquivo)
    @content = Document.new(@arquivo_odt.read("content.xml"))
    root = @content.root
    body = root.elements[4]
    @tag_estilo = root.elements[3]
    @tag_texto = body.elements[1]
  end

  def arquivo
    @arquivo
  end

  def adicionar_imagem(imagem, nome)
    imagem_temporaria = Tempfile.new("nome", Rails.root.join('tmp'))
    imagem_temporaria.write(imagem.force_encoding('UTF-8'))
    imagem_odt = "Pictures/" + nome
    @arquivo_odt.add(imagem_odt, imagem_temporaria)
    size = IO.read(imagem_temporaria)[0x10..0x18].unpack('NN')
    px_to_cm = 0.012
    width, height  = size.map{|i| i * px_to_cm}.map{|x| x.to_s + "cm"}
    element = Element.new("text:p", parent = @tag_texto)
    element.add_attribute "text:style-name","Standard"
    frame = Element.new("draw:frame",parent=element)
    frame.add_attribute("text:anchor-type", "as-char")
    frame.add_attribute("svg:width", width)
    frame.add_attribute("svg:height", height)
    Element.new("draw:image xlink:actuate='onLoad'
                 xlink:href='#{imagem_odt}'
                 xlink:show='embed'
                 xlink:type='simple'", parent=frame)
    imagem_temporaria.close()
  end

  def adicionar_tabela(grao)
    table = ZipFile.open(grao)
    table_parsed = Nokogiri::XML(table.read("content.xml"))
    estilo = table_parsed.xpath("//style:style")
    extrair_estilo(estilo, @tag_estilo)
    tabela = table_parsed.xpath('//table:table').first
    extrair_tabela(tabela, @tag_texto)
  end

  def adicionar_texto(texto)
    Element.new("text:p", @tag_texto).add_text(texto)
  end

  def salvar!
    myfile = Tempfile.new("myfile.xml", Rails.root.join('tmp'))
    @content.write(myfile)
    @arquivo_odt.replace("content.xml", myfile)
    myfile.close
    @arquivo_odt.close
  end

  private

  def novo_elemento(elemento, pai)
    novo = Element.new("#{elemento.namespace.prefix}:#{elemento.node_name}", pai)
    elemento.attribute_nodes.each do |node|
      novo.add_attribute("#{node.namespace.prefix}:#{node.name}", node.value)
    end
    novo
  end

  def extrair_estilo(estilo, elemento_pai)
    estilo.each do |estilo|
      style = novo_elemento estilo , elemento_pai
      tag = novo_elemento estilo.child, style
    end
  end

  def extrair_tabela(tabela, elemento_pai)
    novo = novo_elemento(tabela , elemento_pai)
    tabela.children.each do |filho|
      if filho.namespace.prefix == 'text'
        texto = novo_elemento(filho, novo)
        texto.add_text(filho.text)
      else
        extrair_tabela(filho, novo)
      end
    end
  end
end
