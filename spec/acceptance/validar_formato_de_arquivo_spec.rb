# encoding: utf-8
require 'spec_helper'

feature 'validar formato de arquivo enviado' do
  [:livro, :artigo_de_evento, :artigo_de_periodico, :periodico_tecnico_cientifico,
   :relatorio, :trabalho_de_obtencao_de_grau]
  .each do |tipo|

    before(:each) do
      popular_graus
      popular_area_sub_area
      criar_papeis
      autenticar_usuario(Papel.contribuidor)
    end

    scenario "#{tipo} deve permitir os formatos rtf, doc, odt, ps, pdf" do
      ['arquivo.rtf', 'arquivo.doc', 'arquivo.odt', 'arquivo.ps', 'arquivo.pdf'].each do |arquivo|
        submeter_conteudo tipo, link: '', arquivo: Rails.root + "spec/resources/#{arquivo}"
        page.should have_content 'enviado com sucesso'
      end
    end

    scenario "#{tipo} não deve permitir outros formatos além de rtf, doc, odt, ps, pdf" do
      submeter_conteudo tipo, link: '', arquivo: Rails.root + "spec/resources/arquivo.nsi"
      page.should have_content 'Tipo de arquivo não suportado para o conteúdo'
    end
  end
end
