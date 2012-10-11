# encoding: utf-8

require 'spec_helper'

feature 'Notificar publicação aṕos aprovação de um conteúdo' do
  context 'Conteúdo aprovado' do
    scenario 'notificar publicação' do
      Papel.criar_todos
      usuario = autenticar_usuario(Papel.contribuidor)
      livro = create(:livro_publicado, contribuidor_id: usuario.id)

      visit root_path
      page.should have_selector '#notificacoes_container'
    end

    scenario 'após notificar publicação deve excluir notificação' do
      Papel.criar_todos
      usuario = autenticar_usuario(Papel.contribuidor)
      livro = create(:livro_publicado, contribuidor_id: usuario.id)

      usuario.notificacoes.should_not == []
      visit root_path
      usuario.reload.notificacoes.should == []
    end
  end
end
