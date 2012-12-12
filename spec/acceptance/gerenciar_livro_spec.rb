# encoding: utf-8

require 'spec_helper'

feature 'adicionar livro' do
  scenario 'padrão' do
    visit new_conteudo_path(tipo: :livro)
    submeter_conteudo :livro do
      fill_in 'Direitos', with: 'Direitos e esquerdos'
      fill_in 'Subtítulo', with: 'Rails Rocks'
      fill_in 'Resumo', with: 'Ruby on Rails helps you produce high-quality, beautiful-looking web applications quickly.'
      check 'Tradução'
      fill_in 'Número da Edição', with: '4'
      fill_in 'Local da Publicação', with: 'New York: Manhattan'
      fill_in 'Editora', with: 'The Pragmatic Bookshelf'
      fill_in 'Ano de Publicação', with: '2011'
      fill_in 'Número de Páginas', with: '480'
    end

    validar_conteudo
    page.should have_content 'Livro'
    page.should have_content 'Livro enviado com sucesso'
    page.should have_content 'Direitos e esquerdos'
    page.should have_content 'Rails Rocks'
    page.should have_content 'Ruby on Rails helps you produce high-quality, beautiful-looking web applications quickly.'
    page.should have_content 'Sim'
    page.should have_content '4'
    page.should have_content 'New York: Manhattan'
    page.should have_content 'The Pragmatic Bookshelf'
    page.should have_content '2011'
    page.should have_content '480'
  end

  scenario 'sem tradução' do
    Papel.criar_todos
    usuario = autenticar_usuario(Papel.contribuidor)
    visit conteudo_path(create(:livro, traducao: false, contribuidor: usuario))
    page.should have_content 'Tradução: Não'
  end

  scenario 'editar livro' do
    Papel.criar_todos
    usuario = autenticar_usuario(Papel.contribuidor)
    visit edit_conteudo_path(create :livro, contribuidor: usuario)

    fill_in 'Subtítulo', with: 'Metaprograming Rails'
    click_button 'Salvar'

    page.should have_content 'Metaprograming Rails'
  end
end
