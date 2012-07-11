# encoding: utf-8
require 'spec_helper'

feature 'Devolver conteudo' do
  context 'usuário gestor' do
    scenario 'devolver conteúdo pendente' do
      submeter_conteudo :livro
      livro = Livro.last
      livro.submeter!
      contribuidor = livro.contribuidor

      livro.estado.should == 'pendente'

      gestor = create(:usuario_gestor, campus: livro.campus)
      autenticar(gestor)
      visit conteudo_path(livro)
      click_button 'Devolver'

      livro.reload.estado.should == 'editavel'

      autenticar(contribuidor)
      visit conteudo_path(livro)
      page.should have_content livro.titulo
    end
  end
end
