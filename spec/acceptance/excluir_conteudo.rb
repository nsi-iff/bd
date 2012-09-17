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
    
    Livro.find_by_id(livro.id).should be_nil
  end
end
