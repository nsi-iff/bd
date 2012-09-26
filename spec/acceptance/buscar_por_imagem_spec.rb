# encoding: utf-8

require 'spec_helper'

feature 'buscar por imagem' do
  scenario 'mostra mensagem para busca vazia' do
    visit new_busca_por_imagem_path
    click_button 'Buscar'
    page.should have_content 'Favor incluir uma imagem antes de buscar'
  end
end
