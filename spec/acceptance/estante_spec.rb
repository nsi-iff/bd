# encoding: utf-8

require 'spec_helper'

feature 'Estante' do
  before(:each) { criar_papeis }

  scenario 'mostra os conteúdos do usuário em estado pendente' do
    usuario = autenticar_usuario(Papel.contribuidor)
    outro = Factory.create(:usuario)

    c1 = Factory.create(:artigo_de_evento, titulo: 'Ruby is cool!', contribuidor: usuario)
    c2 = Factory.create(:livro, titulo: 'Agile rulz!', contribuidor: usuario)
    c3 = Factory.create(:relatorio, titulo: 'We love Ruby and Agile!', contribuidor: outro)

    c3.submeter!
    visit root_path
    within "#estante" do
      page.should_not have_content 'Ruby is cool'
      page.should_not have_content 'Agile rulz'
      page.should_not have_content 'We love Ruby and Agile'
    end

    c1.submeter!
    visit root_path
    within "#estante" do
      page.should have_content 'Ruby is cool'
      page.should_not have_content 'Agile rulz'
      page.should_not have_content 'We love Ruby and Agile'
    end

    c1.aprovar!
    c2.submeter!
    visit root_path
    within "#estante" do
      page.should_not have_content 'Ruby is cool'
      page.should have_content 'Agile rulz'
      page.should_not have_content 'We love Ruby and Agile'
    end
  end

  context 'vazia' do
    before :each do
      autenticar_usuario(Papel.contribuidor)
    end

    scenario 'deve mostrar mensagem' do
      visit root_path
      within '#estante' do
        page.should have_content estante_vazia
      end
    end
  end

  scenario 'somente gestores e contribuidores têm estante' do
    { Papel.contribuidor => true,
      Papel.gestor => true,
      Papel.membro => false,
      Papel.admin => false }.each_pair do |papel, tem_estante|
    autenticar_usuario(papel)
    visit root_path
    page.send(tem_estante ? :should : :should_not,
      have_selector('#estante'))
    end
  end
end
