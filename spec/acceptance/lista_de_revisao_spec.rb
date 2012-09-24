# encoding: utf-8

require 'spec_helper'

feature 'Lista de Revisão' do
  before(:each) { Papel.criar_todos }

  scenario 'mostra os conteúdos de todos usuários em estado pendente' do
    meu_campus = create(:campus)
    usuario_gestor = create(:usuario_gestor, campus: meu_campus)
    outro = create(:usuario)

    artigo_editavel = create(:artigo_de_evento, titulo: 'artigo de evento', campus: meu_campus)
    livro_publicado = create(:livro_publicado, titulo: 'livro', campus: meu_campus)
    relatorio_pendente = create(:relatorio_pendente, titulo: 'relatório', campus: meu_campus)
    periodico_pendente = create(:periodico_tecnico_cientifico_pendente, titulo: 'periodico', campus: meu_campus)
    outro_periodico_pendente = create(:periodico_tecnico_cientifico_pendente, titulo: 'mais um')

    autenticar(usuario_gestor)
    visit root_path
    within "#lista_de_revisao" do
      page.should_not have_content 'livro'
      page.should_not have_content 'artigo de evento'
      page.should have_content 'relatório'
      page.should have_content 'periodico'
      page.should_not have_content 'mais um'
    end
  end
end
