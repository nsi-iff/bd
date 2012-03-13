# encoding: utf-8

require 'spec_helper'

feature 'submeter conteúdo a aprovação' do
  scenario 'dono do conteúdo pode submetê-lo a aprovação' do
    criar_papeis
    popular_area_sub_area
    user = autenticar_usuario(Papel.contribuidor)
    livro = Factory.create :livro, contribuidor: user

    visit edit_livro_path(livro)

    within '#escrivaninha' do
      page.should have_content 'Conteudo interessante'
    end
    within '#estante' do
      page.should_not have_content 'Conteudo interessante'
    end

    click_link 'Submeter'

    within '#escrivaninha' do
      page.should_not have_content 'Conteudo interessante'
    end
    within '#estante' do
      page.should have_content 'Conteudo interessante'
    end
  end
end
