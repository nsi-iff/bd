# encoding: utf-8

require 'spec_helper'

feature 'aprovar conteúdo' do

  before(:each) do
    criar_papeis
  end

  scenario 'gestor deve poder aprovar livro pendente' do
    user = autenticar_usuario(Papel.gestor)
    livro = Factory.create :livro, titulo: 'livro'
    livro.submeter

    visit lista_de_revisao_usuario_path(user)
    page.should have_content 'livro'

    visit edit_livro_path(livro)
    click_link 'Aprovar'

    visit lista_de_revisao_usuario_path(user)
    page.should_not have_content 'livro'
  end

  scenario 'gestor deve poder aprovar artigo de evento pendente' do
    user = autenticar_usuario(Papel.gestor)
    artigo_de_evento = Factory.create :artigo_de_evento, titulo: 'artigo de evento'
    artigo_de_evento.submeter

    visit lista_de_revisao_usuario_path(user)
    page.should have_content 'artigo de evento'

    visit edit_artigo_de_evento_path(artigo_de_evento)
    click_link 'Aprovar'

    visit lista_de_revisao_usuario_path(user)
    page.should_not have_content 'artigo de evento'
  end

  scenario 'gestor deve poder aprovar artigo de periódicio pendente' do
    user = autenticar_usuario(Papel.gestor)
    artigo_de_periodico = Factory.create :artigo_de_periodico, titulo: 'artigo de periódico'
    artigo_de_periodico.submeter

    visit lista_de_revisao_usuario_path(user)
    page.should have_content 'artigo de periódico'

    visit edit_artigo_de_periodico_path(artigo_de_periodico)
    click_link 'Aprovar'

    visit lista_de_revisao_usuario_path(user)
    page.should_not have_content 'artigo de periódico'
  end

  scenario 'gestor deve poder aprovar objeto de aprendizagem pendente' do
    user = autenticar_usuario(Papel.gestor)
    popular_area_sub_area
    popular_eixos_tematicos_cursos
    objeto_de_aprendizagem = Factory.create :objeto_de_aprendizagem, titulo: 'objeto de aprendizagem'
    objeto_de_aprendizagem.submeter

    visit lista_de_revisao_usuario_path(user)
    page.should have_content 'objeto de aprendizagem'

    visit edit_objeto_de_aprendizagem_path(objeto_de_aprendizagem)
    click_link 'Aprovar'

    visit lista_de_revisao_usuario_path(user)
    page.should_not have_content 'objeto de aprendizagem'
  end

  scenario 'gestor deve poder aprovar periódico técnico científico pendente' do
    user = autenticar_usuario(Papel.gestor)
    periodico_tecnico_cientifico = Factory.create :periodico_tecnico_cientifico, titulo: 'periódico técnico científico'
    periodico_tecnico_cientifico.submeter

    visit lista_de_revisao_usuario_path(user)
    page.should have_content 'periódico técnico científico'

    visit edit_periodico_tecnico_cientifico_path(periodico_tecnico_cientifico)
    click_link 'Aprovar'

    visit lista_de_revisao_usuario_path(user)
    page.should_not have_content 'periódico técnico científico'
  end

  scenario 'gestor deve poder aprovar relatório pendente' do
    user = autenticar_usuario(Papel.gestor)
    relatorio = Factory.create :relatorio, titulo: 'relatório'
    relatorio.submeter

    visit lista_de_revisao_usuario_path(user)
    page.should have_content 'relatório'

    visit edit_relatorio_path(relatorio)
    click_link 'Aprovar'

    visit lista_de_revisao_usuario_path(user)
    page.should_not have_content 'relatório'
  end

  scenario 'gestor deve poder aprovar trabalho de obtenção de grau pendente' do
    user = autenticar_usuario(Papel.gestor)
    trabalho_de_obtencao_de_grau = Factory.create :trabalho_de_obtencao_de_grau, titulo: 'trabalho de obtenção de grau'
    trabalho_de_obtencao_de_grau.submeter

    visit lista_de_revisao_usuario_path(user)
    page.should have_content 'trabalho de obtenção de grau'

    visit edit_trabalho_de_obtencao_de_grau_path(trabalho_de_obtencao_de_grau)
    click_link 'Aprovar'

    visit lista_de_revisao_usuario_path(user)
    page.should_not have_content 'trabalho de obtenção de grau'
  end
end
