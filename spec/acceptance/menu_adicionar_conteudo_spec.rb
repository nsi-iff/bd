# encoding: utf-8

require 'spec_helper'

feature 'verificar menu adicionar conteúdo' do
  scenario 'link para adicionar livro' do
    visit adicionar_conteudo_path
    within_fieldset 'Adicionar Conteúdo' do
      click_link 'Livro'
    end
    page.current_path.should == "/livros/new"
  end

  scenario 'link para adicionar relatório' do
    visit adicionar_conteudo_path
    within_fieldset 'Adicionar Conteúdo' do
      click_link 'Relatório'
    end
    page.current_path.should == "/relatorios/new"
  end

  scenario 'link para adicionar artigo de evento' do
    visit adicionar_conteudo_path
    within_fieldset 'Adicionar Conteúdo' do
      click_link 'Artigo de Evento'
    end
    page.current_path.should == "/artigos_de_evento/new"
  end

  scenario 'link para adicionar periódico técnico científico' do
    visit adicionar_conteudo_path
    within_fieldset 'Adicionar Conteúdo' do
      click_link 'Periódico Técnico Científico'
    end
    page.current_path.should == "/periodicos_tecnico_cientificos/new"
  end

  scenario 'link para adicionar artigo de periódico' do
    visit adicionar_conteudo_path
    within_fieldset 'Adicionar Conteúdo' do
      click_link 'Artigo de Periódico'
    end
    page.current_path.should == "/artigos_de_periodico/new"
  end
end
