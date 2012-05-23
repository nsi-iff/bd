# encoding: utf-8

require 'spec_helper'

feature 'determinados usuários não podem acessar página de adicionar conteúdo' do
  before(:each) do
    Papel.criar_todos
  end
  scenario 'não cadastrado não pode ver link para adicionar conteúdo' do
    visit root_path
    page.should_not have_content 'Adicionar Conteúdo'
  end

  scenario 'não cadastrado não pode acessar página adicionar conteúdo' do
    visit adicionar_conteudo_path
    current_path.should == new_usuario_session_path
  end

  scenario 'sem permissão não pode ver link para adicionar conteúdo' do
    [Papel.membro, Papel.admin, Papel.gestor].each do |papel|
      autenticar_usuario(papel)
      visit root_path
      page.should_not have_content 'Adicionar Conteúdo'
    end
  end

  scenario 'sem permissão não pode acessar página de adicionar conteúdo' do
    [Papel.membro, Papel.admin, Papel.gestor].each do |papel|
      autenticar_usuario(papel)
      visit adicionar_conteudo_path
      page.should have_content 'Acesso negado'
    end
  end
end

feature 'verificar menu adicionar conteúdo' do
  before(:each) do
    popular_area_sub_area
    Papel.criar_todos
    autenticar_usuario(Papel.contribuidor)
  end

  scenario 'link para adicionar artigo de evento' do
    visit adicionar_conteudo_path
    within_fieldset 'Adicionar Conteúdo' do
      click_link 'Artigo de Evento'
    end
    save_and_open_page
    page.should have_content 'Adicionar Artigo de Evento'
  end

  scenario 'link para adicionar artigo de periódico' do
    visit adicionar_conteudo_path
    within_fieldset 'Adicionar Conteúdo' do
      click_link 'Artigo de Periódico'
    end
    page.should have_content 'Adicionar Artigo de Periódico'
  end

  scenario 'link para adicionar livro' do
    visit adicionar_conteudo_path
    within_fieldset 'Adicionar Conteúdo' do
      click_link 'Livro'
    end
    page.should have_content 'Adicionar Livro'
  end

  scenario 'link para adicionar objeto de aprendizagem' do
    popular_eixos_tematicos_cursos
    visit adicionar_conteudo_path
    within_fieldset 'Adicionar Conteúdo' do
      click_link 'Objeto de Aprendizagem'
    end
    page.should have_content 'Adicionar Objeto de Aprendizagem'
  end

  scenario 'link para adicionar periódico técnico científico' do
    visit adicionar_conteudo_path
    within_fieldset 'Adicionar Conteúdo' do
      click_link 'Periódico Técnico Científico'
    end
    page.should have_content 'Adicionar Periódico Técnico-Científico'
  end

  scenario 'link para adicionar relatório' do
    visit adicionar_conteudo_path
    within_fieldset 'Adicionar Conteúdo' do
      click_link 'Relatório'
    end
    page.should have_content 'Adicionar Relatório'
  end

  scenario 'link para adicionar trabalho de obtenção de grau' do
    visit adicionar_conteudo_path
    within_fieldset 'Adicionar Conteúdo' do
      click_link 'Trabalho de Obtenção de Grau'
    end
    page.should have_content 'Adicionar Trabalho de Obtenção de Grau'
  end
end
