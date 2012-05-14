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
    page.should have_content 'Livro enviado com sucesso'
    page.should have_content 'Direitos: Direitos e esquerdos'
    page.should have_content 'Subtítulo: Rails Rocks'
    page.should have_content 'Resumo: Ruby on Rails helps you produce high-quality, beautiful-looking web applications quickly.'
    page.should have_content 'Tradução: Sim'
    page.should have_content 'Número da Edição: 4'
    page.should have_content 'Local da Publicação: New York: Manhattan'
    page.should have_content 'Editora: The Pragmatic Bookshelf'
    page.should have_content 'Ano de Publicação: 2011'
    page.should have_content 'Número de Páginas: 480'
  end

  scenario 'sem tradução' do
    criar_papeis
    autenticar_usuario(Papel.contribuidor)
    visit conteudo_path(FactoryGirl.create(:livro, traducao: false))
    page.should have_content 'Tradução: Não'
  end

  scenario 'editar livro' do
    criar_papeis
    usuario = autenticar_usuario(Papel.contribuidor)
    visit edit_conteudo_path(FactoryGirl.create :livro, campus: usuario.campus)

    fill_in 'Subtítulo', with: 'Metaprograming Rails'
    click_button 'Salvar'

    page.should have_content 'Subtítulo: Metaprograming Rails'
  end
end
