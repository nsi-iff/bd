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
end
