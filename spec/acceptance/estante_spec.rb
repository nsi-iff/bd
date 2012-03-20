# encoding: utf-8

require 'spec_helper'

feature 'Estante' do
  before(:each) { criar_papeis }

  scenario 'mostra os conteúdos aprovados do usuário' do
    usuario = autenticar_usuario(Papel.contribuidor)
    outro = Factory.create(:usuario)

    artigo = Factory.create(:artigo_de_evento, titulo: 'Ruby is cool!', contribuidor: usuario)
    relatorio = Factory.create(:relatorio, titulo: 'We love Ruby and Agile!', contribuidor: outro)

    artigo.submeter!
    visit root_path
    within '#estante' do
      page.should_not have_content 'Ruby is cool!'
      page.should_not have_content 'We love Ruby and Agile!'
    end

    visit estante_usuario_path(usuario)
    page.should_not have_content 'Ruby is cool!'
    page.should_not have_content 'We love Ruby and Agile!'

    artigo.aprovar!
    visit root_path
    within '#estante' do
      page.should have_content 'Ruby is cool!'
      page.should_not have_content 'We love Ruby and Agile!'
    end

    visit estante_usuario_path(usuario)
    page.should have_content 'Ruby is cool!'
    page.should_not have_content 'We love Ruby and Agile!'
  end
end
