#encoding: utf-8

require './lib/zip_entry.rb'
require './lib/criar_arquivo_zip.rb'
require 'extend_string'
require 'fileutils'
require 'nokogiri'
require 'rubygems'

include REXML
include Zip

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
    send_file criar_arquivo_zip(current_usuario.cesta), :type => 'application/zip',
                      :disposition => 'attachment',
                      :filename => 'cesta-' + Time.now.to_s + '.zip'
  end

  def baixar_conteudo_em_odt
    # TODO: refactoring, mover para model, lib.. ?
    unless current_usuario.cesta.blank?
      documento = DocumentoOdt.new("#{current_usuario.nome_completo}")
      referencias_abnt = []
      current_usuario.cesta.map(&:referenciavel).map(&:key).each do |key|
        grao = Grao.where(:key => key).first
        conteudo_que_gerou_o_grao = Conteudo.where(:id => grao.conteudo_id).first
        referencias_abnt << conteudo_que_gerou_o_grao.referencia_abnt
        dados_grao = grao.conteudo_base64
        grao_string = Base64.decode64(dados_grao)
        if grao.imagem?
          documento.adicionar_imagem(grao_string, grao.titulo)
        else
          arquivo_temporario = Tempfile.new("#{Rails.root}/tmp/#{rand}.odt", "w")
          arquivo_temporario.write(grao_string.force_encoding('UTF-8'))
          documento.adicionar_tabela(arquivo_temporario)
          arquivo_temporario.close()
        end
        documento.adicionar_texto("--------------------------------------")
      end
      documento.adicionar_texto "Referências"
      referencias_abnt.each do |referencia|
        documento.adicionar_texto referencia
      end
      documento.salvar!
      send_file documento.arquivo
    end
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

  def baixar_grao
    # TODO: refactoring, mover para model, lib.. ?
    @grao = Grao.find(params[:grao_id])
    dados_grao = @grao.conteudo_base64
    if @grao.imagem?
      dados_grao = Base64.decode64(dados_grao)
      file_name  = "#{Rails.root}/tmp/#{@grao.titulo}"
      File.new(file_name, "w").write(dados_grao.force_encoding('UTF-8'))
      send_file file_name
    else
      documento = DocumentoOdt.new("#{@grao.titulo}")
      dados_grao = Base64.decode64(dados_grao)
      file_name  = "#{Rails.root}/tmp/#{rand}.odt"
      arquivo_temporario = Tempfile.new(file_name, "w")
      arquivo_temporario.write(dados_grao.force_encoding('UTF-8'))
      documento.adicionar_tabela(arquivo_temporario)
      documento.salvar!
      send_file documento.arquivo
      arquivo_temporario.close()
    end
  end

  def favoritar
    authorize! :favoritar, Grao
    carregar_grao
    unless current_usuario.favorito? @grao
      current_usuario.favoritar(@grao.referencia)
    end
    redirect_to grao_path(@grao.id)
  end

  private

  def carregar_grao
    @grao = Grao.find(params[:id]) if params[:id]
  end
end
