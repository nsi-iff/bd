# encoding: UTF-8

require "spec_helper"

feature 'buscar todos os tipos de conteúdo', busca: true do
  before(:all) do
    Conteudo.index.delete
    autor_1       = Autor.create nome: "Yukihiro Matsumoto",
                                 lattes: "http://lattes.cnpq.br/1234567890"
    autor_2       = Autor.create nome: "Why, the Lucky Stiff",
                                 lattes: "lattes.cnpq.br/6666666666"
    grande_area_1 = Area.create nome: "Ciências Exatas e da Terra"
    grande_area_2 = Area.create nome: "Engenharia"
    sub_area_1    = grande_area_1.sub_areas.create nome: "Ciência da Computação"
    sub_area_2    = grande_area_2.sub_areas.create nome: "Engenharia Nuclear"
    @artigo_de_evento = ArtigoDeEvento.create titulo: "Artigo de Evento",
                                              link: "http://www.rubyconf.org/articles/1",
                                              sub_area: sub_area_2,
                                              campus: "Campos Centro",
                                              autores: [autor_1]
    @artigo_de_periodico = ArtigoDePeriodico.create titulo: "Artigo de Periódico",
                                                    link: "nsi.iff.edu.br",
                                                    sub_area: sub_area_1,
                                                    campus: "Campos Centro",
                                                    autores: [autor_1, autor_2],
                                                    volume_publicacao: 10
    @livro = Livro.create titulo: "Livro",
                          link: "",
                          arquivo: "arquivo.nsi",
                          sub_area: sub_area_1,
                          campus: "Campos Centro",
                          autores: [autor_1, autor_2]
    @objeto_de_aprendizagem = ObjetoDeAprendizagem.create titulo: "Objeto de Aprendizagem",
                                                          link: "http://www.rubyconf.org/articles/1",
                                                          sub_area: sub_area_2,
                                                          campus: "Campos Centro",
                                                          autores: [autor_1]
    @periodico_tecnico_cientifico = PeriodicoTecnicoCientifico.create titulo: "Periodico Tecnico Cientifico",
                                                                       link: "http://www.rubyconf.org/articles/1",
                                                                       sub_area: sub_area_2,
                                                                       campus: "Cabo Frio",
                                                                       autores: [autor_1]
    @relatorio = Relatorio.create titulo: "Relatório",
                                   link: "http://www.rubyconf.org/articles/1",
                                   sub_area: sub_area_1,
                                   campus: "Campos Centro",
                                   autores: [autor_2]
    @trabalho_de_obtencao_de_grau = TrabalhoDeObtencaoDeGrau.create titulo: "Trabalho de Obtencao de Grau",
                                                                     link: "http://www.rubyconf.org/articles/1",
                                                                     sub_area: sub_area_2,
                                                                     campus: "Campos Centro",
                                                                     autores: [autor_1]

    sleep(1) # espera o elasticsearch indexar :(
  end

  scenario 'por título' do
    testar_busca "Artigo", @artigo_de_evento, @artigo_de_periodico
  end

  scenario 'por link' do
    testar_busca "nsi.iff.edu.br", @artigo_de_periodico
  end

  scenario 'por área' do
    testar_busca "Ciências Exatas e da Terra", @livro, @artigo_de_periodico, @relatorio
  end

  scenario 'por sub area' do
    testar_busca "Ciencia da Computação", @livro, @artigo_de_periodico, @relatorio
  end

  scenario 'por campus' do
    testar_busca "Cabo Frio", @periodico_tecnico_cientifico
  end

  scenario 'pesquisar por nome de autor' do
    testar_busca "Why, the Lucky Stiff", @livro, @artigo_de_periodico, @relatorio
  end

  scenario 'pesquisar por Lattes de autor' do
    testar_busca "lattes.cnpq.br/6666666666", @livro, @artigo_de_periodico, @relatorio
  end

  def testar_busca(texto, *resultados)
    visit "/busca"
    fill_in "Busca", with: texto
    click_button "Buscar"
    resultados.each do |resultado|
      page.should have_link resultado.titulo,
                            href: __send__("#{resultado.class.name.underscore}_path", resultado)
    end
  end
end
