# encoding: utf-8

require 'spec_helper'

feature "Área de Conhecimento" do
  scenario "devem mudar quando outra grande área for selecionada", :javascript => true do
    popular_area_sub_area
    visit new_artigo_de_evento_path

    select('Ciências Exatas e da Terra', from: 'Grande Área de Conhecimento')
    select('Ciência da Computação', from: 'Área de Conhecimento*')

    select('Engenharias', from: 'Grande Área de Conhecimento')
    select('Engenharia de Produção', from: 'Área de Conhecimento*')

    select('Ciências Biológicas', from: 'Grande Área de Conhecimento')
    select('Biologia Geral', from: 'Área de Conhecimento*')

    select('Ciências da Saúde', from: 'Grande Área de Conhecimento')
    select('Enfermagem', from: 'Área de Conhecimento*')

    select('Ciências Agrárias', from: 'Grande Área de Conhecimento')
    select('Agronomia', from: 'Área de Conhecimento*')

    select('Ciências Sociais Aplicadas', from: 'Grande Área de Conhecimento')
    select('Administração', from: 'Área de Conhecimento*')

    select('Ciências Humanas', from: 'Grande Área de Conhecimento')
    select('Teologia', from: 'Área de Conhecimento*')

    select('Linguística, Letras e Artes', from: 'Grande Área de Conhecimento')
    select('Letras', from: 'Área de Conhecimento*')

    select('Outras', from: 'Grande Área de Conhecimento')
    select('Biomedicina', from: 'Área de Conhecimento*')

  end
end
