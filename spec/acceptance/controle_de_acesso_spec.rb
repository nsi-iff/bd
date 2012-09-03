# encoding: utf-8

require 'spec_helper'

feature 'controle de acesso' do
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
      usuario = create(:usuario, confirmed_at: nil)
      autenticar(usuario)
      page.should have_content 'Antes de continuar, confirme a sua conta'

      usuario.confirm!
      autenticar(usuario)

      page.should_not have_content 'Antes de continuar, confirme a sua conta'
      page.should have_content 'sucesso'
    end
  end


  context 'gerenciar usuários' do
    scenario 'administrador de instituição não pode atribuir papel de administrador geral' do
      Papel.criar_todos
      usuario = create(:usuario, papeis: [Papel.instituicao_admin])
      autenticar(usuario)
      visit papeis_usuarios_path
      within '#papeis-usuarios' do
        page.should have_content usuario.nome_completo
        page.should_not have_selector :css, '.admin'
      end

      admin = create(:usuario, papeis: [Papel.admin], campus: usuario.campus)
      autenticar(admin)
      visit papeis_usuarios_path
      within '#papeis-usuarios' do
        page.should have_selector :css, '.admin'
      end
    end

    scenario 'administrador não pode se excluir' do
      Papel.criar_todos
      usuario = create(:usuario, papeis: [Papel.admin])
      autenticar(usuario)
      visit papeis_usuarios_path
      within '#papeis-usuarios' do
        page.should have_content usuario.nome_completo
        page.should_not have_selector :css, '.excluir_usuario'
      end

      create(:usuario)
      visit papeis_usuarios_path
      within '#papeis-usuarios' do
        page.should have_selector :css, '.excluir_usuario'
      end
    end
  end
end
