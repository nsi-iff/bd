# encoding: utf-8

require 'spec_helper'
def criar_conteudos_e_acessos
  instituicao1 = create(:instituicao, nome: "IFF")
  instituicao2 = create(:instituicao, nome: "IFRN")

  campus1 = create(:campus, instituicao: instituicao1)
  campus2 = create(:campus, instituicao: instituicao2)
  campus3 = create(:campus, instituicao: instituicao2)

  create(:livro, :numero_de_acessos => 10, :campus => campus1)
  create(:periodico_tecnico_cientifico, :numero_de_acessos => 8, :campus => campus1)
  create(:artigo_de_evento, :numero_de_acessos => 5, :campus => campus1)
  create(:relatorio, :numero_de_acessos => 3, :campus => campus2)
  create(:trabalho_de_obtencao_de_grau, :numero_de_acessos => 2, :campus => campus3)
  visit graficos_de_acessos_path
end

feature 'deve retornar o gráfico ' do

  #TODO Alguma formda de efetuar o Download do Gráfico no teste

  scenario 'dos cinco documentos mais acessados', js: true do

    criar_conteudos_e_acessos
    page.find("#salvar_cinco_acessos").click
  end

  scenario 'dos tipos de conteudo mais acessados', js: true do

    criar_conteudos_e_acessos
    page.find("#salvar_conteudo").click
  end

  scenario 'das areas de conhecimento mais acessados', js: true do

    criar_conteudos_e_acessos
    page.find("#salvar_subarea").click
  end

  scenario 'dos documentos mais acessados', js: true do

    criar_conteudos_e_acessos
    page.find("#salvar_todos_acessos").click
  end
end