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
    tabela = extract_table(Base64.decode64(grao.conteudo_base64)).html_safe
    while "Pictures".in? tabela
      index2 = index1 = tabela.index("Pictures")
      while tabela[index2] != "\n"
        index2 += 1
      end
      (index2 - index1).times{ tabela[index1] = "" }
      tabela.insert(index1, "<span class='aviso_imagem'>AVISO: IMAGEM INDISPONÍVEL</span>")
    end
    tabela
  end

  def renderizar_graos_da_cesta(cesta)
    cesta.
      map {|referencia_id| Referencia.find(referencia_id).referenciavel }.
      map {|grao| renderizar_grao(grao) }.
      join.
      html_safe
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
