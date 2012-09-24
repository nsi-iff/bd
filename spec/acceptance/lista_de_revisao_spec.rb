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

    autenticar(usuario_gestor)
    visit root_path
    within "#lista_de_revisao" do
      page.should_not have_content 'livro'
      page.should_not have_content 'artigo de evento'
      page.should have_content 'relatório'
      page.should have_content 'periodico'
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

  scenario 'não poderá constar na lista de revisão documentos de outras instituições' do
    meu_campus, outro_campus = create(:campus), create(:campus)
    usuario_gestor = create(:usuario_gestor, campus: meu_campus)
    outro_campus_da_minha_instituicao = create(:campus, instituicao: meu_campus.instituicao)

    outro_artigo_pendente = create(:artigo_de_evento,
                                    titulo: 'conteudo de outro instituto',
                                    campus: outro_campus)
    outro_artigo_pendente.submeter!

    meu_artigo_pendente = create(:artigo_de_evento,
                                  titulo:'meu conteudo',
                                  campus: meu_campus)
    meu_artigo_pendente.submeter!

    meu_outro_artigo_pendente = create(:artigo_de_evento,
                                titulo: 'conteudo de outro campus' ,
                                campus: outro_campus_da_minha_instituicao)
    meu_outro_artigo_pendente.submeter!

    editavel = create(:artigo_de_evento, campus: meu_campus)
    aprovado = create(:relatorio, campus: meu_campus)
    aprovado.submeter!
    aprovado.aprovar!


    autenticar(usuario_gestor)
    visit root_path
    within "#lista_de_revisao" do
      page.should_not have_content 'conteudo de outro instituto'
      page.should have_content 'meu conteudo'
    end
  end
end
