# encoding: utf-8

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
    2005..Date.today.year
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

  def documentos_mais_acessados
    Conteudo.all.sort_by(&:numero_de_acessos).reverse
  end

  def cinco_documentos_mais_acessados
    if documentos_mais_acessados.length < 5
      documentos_mais_acessados[0..documentos_mais_acessados.length]
    else
      documentos_mais_acessados[0..4]
    end
  end
end
