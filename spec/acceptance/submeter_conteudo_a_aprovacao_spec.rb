# encoding: utf-8

require 'spec_helper'

feature 'submeter conteúdo a aprovação' do
  scenario 'dono do conteúdo pode submetê-lo a aprovação' do
    criar_papeis
    popular_area_sub_area
    user = autenticar_usuario(Papel.contribuidor)
    popular_eixos_tematicos_cursos

    livro = Factory.create :livro, titulo: 'Rspec book',  contribuidor: user
    artigo_de_evento = Factory.create :artigo_de_evento,
                                      titulo: 'Artigo de evento',
                                      contribuidor: user
    artigo_de_periodico = Factory.create :artigo_de_periodico,
                                         titulo: 'artigo de periódico',
                                         contribuidor: user
    objeto_de_aprendizagem = Factory.create :objeto_de_aprendizagem,
                                            titulo: 'objeto de aprendizagem',
                                            contribuidor: user
    periodico_tecnico_cientifico =
      Factory.create :periodico_tecnico_cientifico,
                     titulo: 'periódico técnico científico',
                     contribuidor: user
    relatorio = Factory.create :relatorio,
                               titulo: 'relatório',
                               contribuidor: user
    trabalho_de_obtencao_de_grau =
      Factory.create :trabalho_de_obtencao_de_grau,
                     titulo: 'trabalho de obtenção de grau',
                     contribuidor: user

    conteudos = [ livro,
                  artigo_de_evento,
                  periodico_tecnico_cientifico,
                  relatorio,
                  artigo_de_periodico,
                  trabalho_de_obtencao_de_grau,
                  objeto_de_aprendizagem
                  ]
    conteudos.each do |conteudo|
      visit send("edit_#{conteudo.class.name.underscore}_path",conteudo)

      within '#escrivaninha' do
        page.should have_content conteudo.titulo
      end

      within '#estante' do
        page.should_not have_content conteudo.titulo
      end

      click_link 'Submeter'

      within '#escrivaninha' do
        page.should_not have_content conteudo.titulo
      end

      within '#estante' do
        page.should have_content conteudo.titulo
      end
    end
  end
end
