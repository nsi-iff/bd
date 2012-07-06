#encoding: utf-8

require './lib/zip_entry.rb'
require 'extend_string'

require 'rubygems'
require 'zip/zipfilesystem';
require 'rexml/document';
require 'fileutils'
require 'zip/zip'

include REXML

require 'rexml/document'; include REXML
require 'zip/zipfilesystem'; include Zip
require 'fileutils'
require 'nokogiri'

class GraosController < ApplicationController
  before_filter :carregar_grao

  def adicionar_a_cesta
    @cesta << @grao.referencia.id
    current_usuario.cesta << @grao.referencia if current_usuario.present?
    respond_to &:js
  end

  def remover_da_cesta
    @cesta.delete(@grao.referencia.id)
    current_usuario.cesta.delete(@grao.referencia) if current_usuario.present?
    respond_to &:js
  end

   def baixar_conteudo
    unless current_usuario.cesta.blank?
      @sam = ServiceRegistry.sam
      t = Tempfile.new("cesta_temporaria", tmpdir="#{Rails.root}/tmp")
      @referencias_abnt = ""
      Zip::ZipOutputStream.open(t.path) do |z|
        current_usuario.cesta.all.map {|referencia|
          referencia.referenciavel.key
        }.each_with_index do |key, index|
          grao = Grao.where(:key => key).first
          conteudo_que_gerou_o_grao = Conteudo.where(:id => grao.conteudo_id).first
          nome_conteudo = conteudo_que_gerou_o_grao.titulo.removeaccents.titleize.delete(" ").underscore
          tipo_grao = grao.tipo
          dados_grao = @sam.get(key)['data']
          title = 'grao_' + nome_conteudo +  '_' + index.to_s
          if tipo_grao == 'images'
            nome_grao = dados_grao['filename']
            formato_grao = nome_grao[-4..-1]
            title += formato_grao
          else
            title += '.odt'
          end
          @referencias_abnt << "#{title}: #{conteudo_que_gerou_o_grao.referencia_abnt}\n"
          z.put_next_entry(title)
          z.print Base64.decode64(dados_grao['file'])
        end
        z.put_next_entry "referencias_ABNT.txt"
        z.print @referencias_abnt
      end
    end
    send_file t.path, :type => 'application/zip',
                      :disposition => 'attachment',
                      :filename => 'cesta-' + Time.now.to_s + '.zip'
    t.close
  end

  def baixar_conteudo_em_odt
    unless current_usuario.cesta.blank?
      @sam = ServiceRegistry.sam
      template_modelo = "#{Rails.root}/public/template.odt"
      template = File.join("#{Rails.root}/tmp/graos.odt")
      FileUtils.cp(template_modelo, template)
      odt = Zip::ZipFile.open(template)
      doc = Document.new(odt.read("content.xml"))
      root = doc.root
      body = root.elements[4]
      office_style = root.elements[3]
      text = body.elements[1]
      referencias_abnt = []
      current_usuario.cesta.map(&:referenciavel).map(&:key).each do |key|
        grao = Grao.where(:key => key).first
        conteudo_que_gerou_o_grao = Conteudo.where(:id => grao.conteudo_id).first
        referencias_abnt << conteudo_que_gerou_o_grao.referencia_abnt
        dados_grao = @sam.get(key)['data']
        if grao.tipo == "images"
          adicionar_imagem(dados_grao, odt, text)
        else
          dados_grao = Base64.decode64(dados_grao['file'])
          file_name  = "#{Rails.root}/tmp/#{rand}.odt"
          File.new(file_name, "w").write(dados_grao.force_encoding('UTF-8'))
          adicionar_tabela(file_name, office_style, text)
        end
        2.times{
          Element.new("text:p", parent=text).add_attribute("text:style-name", "Standard")
        }
      end
      Element.new("text:p", text).add_text("Referências")
      referencias_abnt.each do |referencia|
        Element.new("text:p", text).add_text(referencia)
      end
      myfile = File.open("myfile.xml", "w")
      doc.write(myfile)
      odt.replace("content.xml", "myfile.xml")
      myfile.close
      odt.close
      send_file template
    end
  end

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

  def adicionar_tabela(grao, office_style, text)
    table = ZipFile.open(grao)
    table_parsed = Nokogiri::XML(table.read("content.xml"))
    estilo = table_parsed.xpath("//style:style")
    extrair_estilo(estilo, office_style)
    tabela = table_parsed.xpath('//table:table').first
    extrair_tabela(tabela, text)
    File.delete(grao)
  end

  def adicionar_imagem(dados_grao, odt, content)
    nome_grao = dados_grao['filename']
    path_imagem = "#{Rails.root}/tmp/#{nome_grao}"
    File.new(path_imagem, 'w').write(Base64.decode64(dados_grao['file']).force_encoding('UTF-8'))
    imagem_odt = "Pictures/" + nome_grao
    odt.add(imagem_odt, path_imagem)
    size = IO.read(path_imagem)[0x10..0x18].unpack('NN')
    px_to_cm = 0.012
    width, height  = size.map{|i| i * px_to_cm}.map{|x| x.to_s + "cm"}
    element = Element.new("text:p", parent = content)
    element.add_attribute "text:style-name","Standard"
    frame = Element.new("draw:frame",parent=element)
    frame.add_attribute("text:anchor-type", "as-char")
    frame.add_attribute("svg:width", width)
    frame.add_attribute("svg:height", height)
    Element.new("draw:image xlink:actuate='onLoad' xlink:href='#{imagem_odt}' xlink:show='embed' xlink:type='simple'", parent=frame)
  end

  def cesta
  end

  def favoritar_graos
    authorize! :favoritar, Grao
    current_usuario.cesta.each do |referencia|
      current_usuario.favoritar(referencia)
    end
    current_usuario.cesta = []
    redirect_to :back
  end

  def editar
    respond_to &:js
  end

  def show
    carregar_grao
  end

  private

  def carregar_grao
    @grao = Grao.find(params[:id]) if params[:id]
  end
end
