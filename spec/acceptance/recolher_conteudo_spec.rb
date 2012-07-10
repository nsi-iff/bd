# encoding: utf-8
require 'spec_helper'

feature 'Recolher Conteúdo' do
  context 'usuário gestor' do
    scenario 'recolher conteúdo pendente' do
      submeter_conteudo :livro
      livro = Livro.last
      livro.submeter!
      contribuidor = livro.contribuidor

      gestor = create(:usuario_gestor, campus: livro.campus)
      autenticar(gestor)
      visit conteudo_path(livro)
      click_button 'Recolher'

      livro.reload.estado.should == 'recolhido'

      autenticar(contribuidor)
      visit conteudo_path(livro)
      current_path.should == root_path
    end

    scenario 'recolher conteúdo publicado' do
      submeter_conteudo :livro
      livro = Livro.last
      livro.submeter!; livro.aprovar!
      contribuidor = livro.contribuidor

      gestor = create(:usuario_gestor, campus: livro.campus)
      autenticar(gestor)
      visit conteudo_path(livro)
      click_button 'Recolher'

      livro.reload.estado.should == 'recolhido'

      autenticar(contribuidor)
      visit conteudo_path(livro)
      current_path.should == root_path
      page.should have_content 'Erro'
    end

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
