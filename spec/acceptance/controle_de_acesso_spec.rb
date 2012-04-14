# encoding: utf-8

require 'spec_helper'

feature 'controle de acesso' do
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
