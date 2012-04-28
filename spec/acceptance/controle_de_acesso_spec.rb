# encoding: utf-8

require 'spec_helper'

feature 'controle de acesso' do

  context 'ver conteúdo' do
    scenario 'qualquer usuário inclusive convidados podem ver conteúdo publicado' do
      criar_papeis
      livro = Factory.create(:livro)
      livro.submeter!
      livro.aprovar!

      visit conteudo_path(livro)

      page.should have_content 'Metadados'
      page.should_not have_content 'Acesso negado'
    end

    scenario 'apenas dono do conteúdo pode vê-lo em estado editavel' do
      usuario1 = autenticar_usuario(Papel.contribuidor)
      livro = Factory.create(:livro, contribuidor: usuario1)

      visit conteudo_path(livro)
      page.should have_content 'Metadados'

      autenticar_usuario
      visit conteudo_path(livro)
      page.should_not have_content 'Metadados'
      page.should have_content 'Acesso negado'
    end
  end
  context 'adicionar conteudos' do
    scenario 'pode ser acessado por contribuidores de conteúdo' do
      criar_papeis
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
end
