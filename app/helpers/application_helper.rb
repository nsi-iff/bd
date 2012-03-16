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

  def anos_for_select
    options_for_select((2005..Date.today.year))
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
end
