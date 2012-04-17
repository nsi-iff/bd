# encoding: utf-8

require 'spec_helper'

feature 'cesta de grãos' do
  before(:all) { require File.join(Rails.root, *%w(db criar_indices)) }
  before(:each) { criar_papeis }

  scenario 'incluir grão na cesta', javascript: true do
    livro = Factory.create(:livro, titulo: 'Quantum Mechanics for Dummies')
    Factory.create(:grao_imagem, key: '12345', conteudo: livro)
    Factory.create(:grao_arquivo, key: '67890', conteudo: livro)
    sleep(3) if ENV['INTEGRACAO']

    # monkeypatch temporario para passar no teste sem o Elastic Search
    def Conteudo.search(param)
      where('upper(titulo) like ?', "%#{param.to_s.upcase}%")
    end

    visit "/buscas"
    fill_in "Busca", with: 'Mechanics'
    click_button "Buscar"

    within('#resultado li:nth-child(1) #graos div:nth-child(1)') do
      click_link 'Adicionar à cesta'
    end
    within('#cesta .item') { page.should have_content '12345 imagem' }

    visit "/buscas"
    fill_in "Busca", with: 'for Dummies'
    click_button "Buscar"

    within('#resultado li:nth-child(1) #graos div:nth-child(2)') do
      click_link 'Adicionar à cesta'
    end
    within('#cesta #items div:nth-child(2)') do
      page.should have_content '67890 arquivo'
    end
  end
end
