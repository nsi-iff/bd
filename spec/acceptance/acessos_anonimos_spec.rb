# encoding: utf-8

require 'spec_helper'

feature 'acessos anônimos' do
  scenario 'busca por imagem' do
    visit root_path
    click_link 'Busca por Imagem'
    page.should have_css "div.busca_por_imagem_form"
  end
end
