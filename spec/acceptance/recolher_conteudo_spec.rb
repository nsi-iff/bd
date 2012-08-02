# encoding: utf-8
require 'spec_helper'

feature 'Recolher Conteúdo' do
  context 'usuário gestor' do
    scenario 'apenas gestores podem ver conteúdos recolhidos' do
      Papel.criar_todos
      livro = create(:livro)
      livro.submeter!; livro.recolher!
      autenticar(create(:usuario_contribuidor))
      visit conteudo_path(livro)
      current_path.should == root_path

      autenticar(create(:usuario_gestor))
      visit conteudo_path(livro)
      page.should have_content livro.titulo
    end
  end
end
