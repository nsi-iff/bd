# encoding: utf-8

require 'spec_helper'

feature 'Alterar estado de um conteúdo' do
  context 'usuário gestor' do
    scenario 'Alterar estado de um conteúdo de "Publicado" para "Pendente"' do
      Papel.criar_todos
      gestor = autenticar_usuario(Papel.gestor)
      conteudo = create(:livro)
      conteudo.campus_id = gestor.campus_id
      conteudo.submeter! && conteudo.aprovar!

      conteudo.estado.should == 'publicado'

      visit conteudo_path(conteudo)
      click_button 'Retornar para revisão'

      conteudo.reload.estado.should == 'pendente'
    end
  end
end
