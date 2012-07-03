# encoding: utf-8

require 'spec_helper'

feature 'Lista de Revisão' do
  before(:each) { Papel.criar_todos }

  scenario 'mostra os conteúdos de todos usuários em estado pendente' do
    meu_campus = create(:campus)
    usuario_gestor = create(:usuario_gestor, campus: meu_campus)
    outro = create(:usuario)

    artigo = create(:artigo_de_evento, titulo: 'artigo de evento', campus: meu_campus)
    livro = create(:livro, titulo: 'livro', campus: meu_campus)
    relatorio = create(:relatorio, titulo: 'relatório', contribuidor: outro)

    relatorio.submeter!
    autenticar(usuario_gestor)
    
    visit root_path
    within "#lista_de_revisao" do
      page.should_not have_content 'livro'
      page.should_not have_content 'artigo de evento'
      page.should_not have_content 'relatório'
    end

    artigo.submeter!
    visit root_path
    within "#lista_de_revisao" do
      page.should_not have_content 'livro'
      page.should have_content 'artigo de evento'
      page.should_not have_content 'relatório'
    end

    artigo.aprovar!
    livro.submeter!
    visit root_path
    within "#lista_de_revisao" do
      page.should have_content 'livro'
      page.should_not have_content 'artigo de evento'
      page.should_not have_content 'relatório'
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
