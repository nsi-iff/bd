# encoding: utf-8
require 'spec_helper'

feature 'Excluir conteúdo' do
  before(:each) do
    Papel.criar_todos
  end

  scenario 'excluir conteúdo' do
    usuario = criar_usuario(Papel.contribuidor)
    livro = create(:livro, contribuidor: usuario)
    autenticar(usuario)

    visit conteudo_path(livro)
    click_button 'Excluir'

    expect { visit conteudo_path(livro) }.to raise_error ActiveRecord::RecordNotFound
  end

  scenario 'não pode excluir conteúdo sem estar editavel' do
    usuario = criar_usuario(Papel.contribuidor)
    livro = create(:livro, contribuidor: usuario)
    livro.submeter!
    autenticar(usuario)
    visit conteudo_path(livro)

    page.should_not have_button 'Excluir'
  end
end
