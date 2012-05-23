# encoding: utf-8

require 'spec_helper'

feature 'controle de acesso' do
  context 'ver conteúdo' do
    before(:each) do
      Papel.criar_todos
    end

    scenario 'qualquer usuário inclusive convidados podem ver conteúdo publicado' do
      livro = FactoryGirl.create(:livro)
      livro.submeter!
      livro.aprovar!

      visit conteudo_path(livro)

      page.should have_content 'Metadados'
      page.should_not have_content 'Acesso negado'
    end

    scenario 'apenas dono do conteúdo pode vê-lo em estado editavel' do
      usuario1 = autenticar_usuario(Papel.contribuidor)
      livro = FactoryGirl.create(:livro, contribuidor: usuario1)

      visit conteudo_path(livro)
      page.should have_content 'Metadados'

      autenticar_usuario
      visit conteudo_path(livro)
      page.should_not have_content 'Metadados'
      page.should have_content 'Acesso negado'
    end
  end
  context 'adicionar conteudos' do
    before(:each) do
      Papel.criar_todos
    end

    scenario 'usuário contribuidor não pertencente a nenhum instituto não pode adicionar conteúdo' do
      usuario = autenticar_usuario(Papel.contribuidor)

      campus_nao_federais.each do |campus|
        usuario.campus = campus[0]
        usuario.save!
        visit adicionar_conteudo_path

        page.should have_content 'Acesso negado'
        page.should_not have_content '#adicionar_conteudo'
      end
    end

    scenario 'pode ser acessado por contribuidores de conteúdo' do
      popular_area_sub_area
      popular_eixos_tematicos_cursos
      autenticar_usuario(Papel.contribuidor)
      tipos_de_conteudo.each do |tipo|
        visit new_conteudo_path(tipo: tipo)
        page.should_not have_content acesso_negado
      end

      [Papel.gestor, Papel.admin, Papel.membro].each do |papel|
        autenticar_usuario(papel)
        tipos_de_conteudo.each do |tipo|
          visit new_conteudo_path(tipo: tipo)
          page.should have_content acesso_negado
        end
      end
    end
  end
  context 'criar usuário' do
    before(:each) do
      Papel.criar_todos
    end
    scenario 'usuário criado não tem o acesso liberado antes de confirmar sua conta' do
      usuario = FactoryGirl.create(:usuario, confirmed_at: nil)
      autenticar(usuario)
      page.should have_content 'Antes de continuar, confirme a sua conta'

      usuario.confirm!
      autenticar(usuario)

      page.should_not have_content 'Antes de continuar, confirme a sua conta'
      page.should have_content 'sucesso'
    end
  end
end

