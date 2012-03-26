# encoding: utf-8

require 'spec_helper'

feature 'submeter conteúdo a aprovação' do
  before (:each) do
    criar_papeis
    popular_area_sub_area
    popular_eixos_tematicos_cursos
  end

  let(:user) { autenticar_usuario(Papel.contribuidor) }

  [:livro, :artigo_de_evento, :artigo_de_periodico, :objeto_de_aprendizagem,
   :periodico_tecnico_cientifico, :relatorio, :trabalho_de_obtencao_de_grau].
    each do |tipo|
      scenario "dono do #{tipo} pode submetê-lo a aprovação" do
        conteudo = Factory.create(tipo, contribuidor: user)

        visit send("edit_#{tipo}_path",conteudo)
        click_link 'Submeter'
        visit send("edit_#{tipo}_path",conteudo)

        page.should_not have_content 'Submeter'
        within '#escrivaninha' do
          page.should have_content conteudo.titulo
        end
    end
  end
end
