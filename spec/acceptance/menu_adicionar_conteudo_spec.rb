# encoding: utf-8

require 'spec_helper'

feature 'determinados usuários não podem acessar página de adicionar conteúdo' do
  scenario 'não cadastrado não pode ver link para adicionar conteúdo' do
    visit root_path
    page.should_not have_content 'Adicionar Conteúdo'
  end

  scenario 'não cadastrado pode acessar página adicionar conteúdo' do
    visit adicionar_conteudo_path
    current_path.should == new_usuario_session_path
  end

  scenario 'sem permissão não pode ver link para adicionar conteúdo' do
    criar_papeis
    autenticar_usuario
    visit root_path
    page.should_not have_content 'Adicionar Conteúdo'
  end

  scenario 'sem permissão não pode acessar página de adicionar conteúdo' do
    criar_papeis
    autenticar_usuario
    visit adicionar_conteudo_path
    page.should have_content 'Acesso negado'
  end
end

feature 'verificar menu adicionar conteúdo' do
  before(:each) do
    popular_area_sub_area
    criar_papeis
    autenticar_usuario(Papel.contribuidor)
  end

  scenario 'link para adicionar artigo de evento' do
    visit adicionar_conteudo_path
    within_fieldset 'Adicionar Conteúdo' do
      click_link 'Artigo de Evento'
    end
    current_path.should == new_artigo_de_evento_path
  end

  scenario 'link para adicionar artigo de periódico' do
    visit adicionar_conteudo_path
    within_fieldset 'Adicionar Conteúdo' do
      click_link 'Artigo de Periódico'
    end
    current_path.should == new_artigo_de_periodico_path
  end

  scenario 'link para adicionar livro' do
    visit adicionar_conteudo_path
    within_fieldset 'Adicionar Conteúdo' do
      click_link 'Livro'
    end
    current_path.should == new_livro_path
  end

  scenario 'link para adicionar objeto de aprendizagem' do
    popular_eixos_tematicos_cursos
    visit adicionar_conteudo_path
    within_fieldset 'Adicionar Conteúdo' do
      click_link 'Objeto de Aprendizagem'
    end
    current_path.should == new_objeto_de_aprendizagem_path
  end

  scenario 'link para adicionar periódico técnico científico' do
    visit adicionar_conteudo_path
    within_fieldset 'Adicionar Conteúdo' do
      click_link 'Periódico Técnico Científico'
    end
    current_path.should == new_periodico_tecnico_cientifico_path
  end

  scenario 'link para adicionar relatório' do
    visit adicionar_conteudo_path
    within_fieldset 'Adicionar Conteúdo' do
      click_link 'Relatório'
    end
    current_path.should == new_relatorio_path
  end

  scenario 'link para adicionar trabalho de obtenção de grau' do
    visit adicionar_conteudo_path
    within_fieldset 'Adicionar Conteúdo' do
      click_link 'Trabalho de Obtenção de Grau'
    end
    current_path.should == new_trabalho_de_obtencao_de_grau_path
  end
end

