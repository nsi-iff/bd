# encoding: utf-8

require 'spec_helper'

feature 'Estante' do
  scenario 'mostra os conteúdos do usuário em estado pendente' do
    criar_papeis
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
end
