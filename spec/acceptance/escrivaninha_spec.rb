# encoding: utf-8

require 'spec_helper'

feature 'Escrivaninha' do
  before(:each) { criar_papeis }

  scenario 'mostra os conteúdos do usuário em estado de edição' do
    usuario = autenticar_usuario(Papel.contribuidor)
    outro = Factory.create(:usuario_contribuidor)
    c1 = Factory.create(:artigo_de_evento, titulo: 'Ruby is cool!', contribuidor: usuario)
    c2 = Factory.create(:livro, titulo: 'Agile rulz!', contribuidor: usuario)
    c3 = Factory.create(:relatorio, titulo: 'We love Ruby and Agile!', contribuidor: outro)

    visit root_path
    within '#escrivaninha' do
      page.should have_content 'Ruby is cool'
      page.should have_content 'Agile rulz'
      page.should_not have_content 'We love Ruby and Agile'
    end

    c2.submeter!
    visit root_path
    within '#escrivaninha' do
      page.should have_content 'Ruby is cool'
      page.should_not have_content 'Agile rulz'
      page.should_not have_content 'We love Ruby and Agile'
    end
  end

  context 'vazia' do
    before :each do
      autenticar_usuario(Papel.contribuidor)
    end

    scenario 'deve mostrar mensagem' do
      visit root_path
      within '#escrivaninha' do
        page.should have_content escrivaninha_vazia
      end
    end
  end
end
