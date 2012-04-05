# encoding: utf-8

require 'spec_helper'

feature 'aprovar conteúdo' do
  before(:each) do
    criar_papeis
    popular_area_sub_area
    popular_eixos_tematicos_cursos
  end

  [:livro, :artigo_de_evento, :artigo_de_periodico, :objeto_de_aprendizagem,
   :periodico_tecnico_cientifico, :relatorio, :trabalho_de_obtencao_de_grau].
   each do |tipo|
    scenario "gestor deve poder aprovar #{tipo} pendente" do
      user = autenticar_usuario(Papel.gestor)
      conteudo = Factory.create(tipo)
      conteudo.submeter!

      visit lista_de_revisao_usuario_path(user)
      page.should have_content conteudo.titulo

      visit send("edit_#{tipo}_path", conteudo)
      click_link 'Aprovar'

      visit lista_de_revisao_usuario_path(user)
      page.should_not have_content conteudo.titulo
    end
  end
end
