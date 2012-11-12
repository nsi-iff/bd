# encoding: utf-8

require 'base64'
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

module ApplicationHelper
  def title
    base_title = "Biblioteca Digital da EPCT"
    if @title.nil?
      base_title
    else
      "#{@title} | #{base_title}"
    end
  end

  def anos
    Date.today.year.downto 2005
  end

  def meses
    {
      'Janeiro' => 1,
      'Fevereiro' => 2,
      'Março' => 3,
      'Abril' => 4,
      'Maio' => 5,
      'Junho' => 6,
      'Julho' => 7,
      'Agosto' => 8,
      'Setembro' => 9,
      'Outubro' => 10,
      'Novembro' => 11,
      'Dezembro' => 12
    }.to_a
  end

  def url_para_form_conteudo(conteudo)
    if conteudo.new_record?
      conteudos_path(tipo: @conteudo.nome_como_simbolo)
    else
      conteudo_path(@conteudo)
    end
  end

  def conteudo_tag(conteudo, no_portlet = false)
    titulo = conteudo.titulo
    titulo = titulo_para_portlet(titulo) if no_portlet
    "<span class='conteudo_tag conteudo-#{conteudo.class.name.to_s.underscore}'>#{titulo}</span>".html_safe
  end

  def titulo_para_portlet(titulo)
    Rails.env.test? ? titulo : "#{titulo[0..16]}\n#{(titulo[17..40] && titulo[17..40].strip + '...') || ''}"
  end

  def tabela_grao(grao)
    extract_table(Base64.decode64(grao.conteudo_base64)).html_safe
  end

  def renderizar_graos_da_cesta(cesta)
    cesta.
      map {|referencia_id| Referencia.find(referencia_id).referenciavel }.
      map {|grao| renderizar_grao(grao) }.
      join.
      html_safe
  end

  def limitar_para_portlet(lista, opcoes = {})
    lista = lista.reverse if opcoes[:reverse]
    limite = Rails.application.config.limite_de_itens_nos_portlets - 1
    lista[0..limite]
  end

  def mostra_link_ver_todos_para_portlet?(lista)
    limitar_para_portlet(lista).count < lista.count
  end

  private

  def renderizar_grao(grao)
    if grao.imagem?
      imagem_grao(grao)
    elsif grao.arquivo?
      tabela_grao(grao)
    end
  end

  def imagem_grao(grao)
    "<img src='data:image/xyz;base64,#{grao.conteudo_base64}'>"
  end
end
