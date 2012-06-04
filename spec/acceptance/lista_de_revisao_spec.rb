# encoding: utf-8

require 'spec_helper'

feature 'Lista de Revisão' do
  before(:each) { Papel.criar_todos }

  scenario 'mostra os conteúdos de todos usuários em estado pendente' do
    autenticar_usuario(Papel.gestor)
    outro = create(:usuario)

    artigo = create(:artigo_de_evento, titulo: 'artigo de evento')
    livro = create(:livro, titulo: 'livro')
    relatorio = create(:relatorio, titulo: 'relatório', contribuidor: outro)

    relatorio.submeter!
    visit root_path
    within "#lista_de_revisao" do
      page.should_not have_content 'livro'
      page.should_not have_content 'artigo de evento'
      page.should have_content 'relatório'
    end

    artigo.submeter!
    visit root_path
    within "#lista_de_revisao" do
      page.should_not have_content 'livro'
      page.should have_content 'artigo de evento'
      page.should have_content 'relatório'
    end

    artigo.aprovar!
    livro.submeter!
    visit root_path
    within "#lista_de_revisao" do
      page.should have_content 'livro'
      page.should_not have_content 'artigo de evento'
      page.should have_content 'relatório'
    end
  end

  scenario 'somente gestores têm lista de revisão' do
    { Papel.contribuidor => false,
      Papel.gestor => true,
      Papel.membro => false,
      Papel.admin => false }.each_pair do |papel, tem_lista_de_revisao|
    autenticar_usuario(papel)
    visit root_path
    page.send(tem_lista_de_revisao ? :should : :should_not,
      have_selector('#lista_de_revisao'))
    end
  end
end
