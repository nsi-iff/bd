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

  scenario 'envia conteúdo para granularização ao aprovar' do
    autenticar_usuario(Papel.contribuidor)
    submeter_conteudo :artigo_de_evento, link: '',
      arquivo: File.join(Rails.root, *%w(spec resources manual.odt))
    artigo = ArtigoDeEvento.last
    artigo.submeter!

    autenticar_usuario(Papel.gestor)
    visit edit_artigo_de_evento_path(artigo)
    click_link 'Aprovar'

    visit artigo_de_evento_path(artigo)
    page.should have_content '3 grãos'
  end
end
