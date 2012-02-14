# encoding: utf-8

require 'spec_helper'

feature 'verificar menu adicionar conteúdo' do
  scenario 'link para adicionar artigo de evento' do
    popular_area_sub_area
    visit adicionar_conteudo_path
    within_fieldset 'Adicionar Conteúdo' do
      click_link 'Artigo de Evento'
    end
    current_path.should == new_artigo_de_evento_path
  end

  scenario 'link para adicionar artigo de periódico' do
    popular_area_sub_area
    visit adicionar_conteudo_path
    within_fieldset 'Adicionar Conteúdo' do
      click_link 'Artigo de Periódico'
    end
    current_path.should == new_artigo_de_periodico_path
  end

  scenario 'link para adicionar livro' do
    popular_area_sub_area
    visit adicionar_conteudo_path
    within_fieldset 'Adicionar Conteúdo' do
      click_link 'Livro'
    end
    current_path.should == new_livro_path
  end

  scenario 'link para adicionar objeto de aprendizagem' do
    popular_area_sub_area
    visit adicionar_conteudo_path
    within_fieldset 'Adicionar Conteúdo' do
      click_link 'Objeto de Aprendizagem'
    end
    current_path.should == new_objeto_de_aprendizagem_path
  end

  scenario 'link para adicionar periódico técnico científico' do
    popular_area_sub_area
    visit adicionar_conteudo_path
    within_fieldset 'Adicionar Conteúdo' do
      click_link 'Periódico Técnico Científico'
    end
    current_path.should == new_periodico_tecnico_cientifico_path
  end

  scenario 'link para adicionar relatório' do
    popular_area_sub_area
    visit adicionar_conteudo_path
    within_fieldset 'Adicionar Conteúdo' do
      click_link 'Relatório'
    end
    current_path.should == new_relatorio_path
  end

  scenario 'link para adicionar trabalho de obtenção de grau' do
    popular_area_sub_area
    visit adicionar_conteudo_path
    within_fieldset 'Adicionar Conteúdo' do
      click_link 'Trabalho de Obtenção de Grau'
    end
    current_path.should == new_trabalho_de_obtencao_de_grau_path
  end
end
