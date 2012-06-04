# encoding: utf-8

require 'base64'

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

  def conteudo_tag(conteudo)
    "<span class='conteudo_tag conteudo-#{conteudo.class.name.to_s.underscore}'>#{conteudo.titulo}</span>".html_safe
  end

  def tabela_grao(grao)
    extract_table(Base64.decode64(grao.conteudo_base64)).html_safe
  end
end
