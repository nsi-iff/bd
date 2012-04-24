#coding: utf-8
require "spec_helper"

describe ReferenciaBibliografica do
  class Documento
    include ReferenciaBibliografica
  end

  subject { Documento.new }

  it "referencia para trabalho de obtenção de grau" do
    subject.stub('tipo') { 'TrabalhoDeObtencaoDeGrau' }
    subject.stub('autores') { 'Ian Fantucci' }
    subject.stub('titulo') { 'Contribuição do alerta, da atenção, '\
    'da intenção e da expectativa temporal para o desempenho de '\
    'humanos em tarefas de tempo de reação' }
    subject.stub('subtitulo') { nil }
    subject.stub('data_defesa_br') { '2001' }
    subject.stub('numero_paginas') { '130' }
    subject.stub('tipo_trabalho') { 'Tese (Doutorado em Psicologia)' }
    subject.stub('instituicao') { 'Instituto de Psicologia, '\
    'Universidade de São Paulo' }
    subject.stub!('local_defesa') { 'São Paulo' }

    subject.referencia_abnt.should == (
      'FANTUCCI, I. Contribuição do alerta, da atenção, da intenção e da'\
      ' expectativa temporal para o desempenho de humanos em tarefas de '\
      'tempo de reação. 2001. 130 f. Tese (Doutorado em Psicologia) - '\
      'Instituto de Psicologia, Universidade de São Paulo, São Paulo.')
  end

  it "referencia para artigos de anais de eventos" do
    subject.stub('tipo') { 'artigo de anais de eventos' }
    subject.stub('autores') { 'Antônio Fernandes Bueno Moreira' }
    subject.stub('titulo') { 'Multiculturalismo, Currículo e '\
                             'Formação de Professores' }
    subject.stub('subtitulo') { nil }
    subject.stub('nome_evento') { 'SEMINÁRIO DE EDUCAÇÃO BÁSICA' }
    subject.stub('numero_evento') { '2' }
    subject.stub('ano_evento') { '1998' }
    subject.stub('local_evento') { 'Santa Cruz do Sul' }
    subject.stub('titulo_anais') { 'Anais' }
    subject.stub('local_publicacao') { 'Santa Cruz do Sul' }
    subject.stub('editora') { 'EDUNISC' }
    subject.stub('ano_publicacao') { '1998' }
    subject.stub('pagina_inicial') { '15' }
    subject.stub('pagina_final') { '30' }

    subject.referencia_abnt.should == (
      'MOREIRA, A. F. B. Multiculturalismo, Currículo e Formação de '\
      'Professores. In: SEMINÁRIO DE EDUCAÇÃO BÁSICA, 2., 1998, Santa '\
      'Cruz do Sul. Anais. Santa Cruz do Sul: EDUNISC, 1998. P. 15-30.')
  end

  it "referencia de artigo de periodico" do
    subject.stub('tipo') { 'ArtigoDePeriodico' }
    subject.stub('autores') { 'Demerval Saviani' }
    subject.stub('titulo') { 'A Universidade e a Problemática da Educação e Cultura' }
    subject.stub('subtitulo') { nil }
    subject.stub('nome_periodico') { 'Educação Brasileira' }
    subject.stub('local_publicacao') { 'Brasília' }
    subject.stub('volume') { '1' }
    subject.stub('fasciculo') { '3' }
    subject.stub('pagina_inicial')  { '35' }
    subject.stub('pagina_final') { '58' }
    subject.stub('data_publicacao') { '1979' }

    subject.referencia_abnt.should == (
      "SAVIANI, D. A Universidade e a Problemática da Educação e Cultura."\
      " Educação Brasileira, Brasília, v. 1, n. 3, p. 35-58, 1979.")
  end

  it "referencia de periodico tecnico cientifico" do
    subject.stub('tipo') { 'periodico tecnico cientifico' }
    subject.stub('titulo') { 'EDUCAÇÃO & REALIDADE' }
    subject.stub('local_publicacao') { 'Porto Alegre' }
    subject.stub('editora') { 'UFRGS/FACED' }
    subject.stub('ano_primeiro_volume') { '1975' }
    subject.stub('ano_ultimo_volume') { nil }

    subject.referencia_abnt.should == (
      'EDUCAÇÃO & REALIDADE. Porto Alegre:'\
      ' UFRGS/FACED, 1975-')
  end

  it "referencia de livro" do
    subject.stub('tipo') { 'livro' }
    subject.stub('autores') { 'Marcos Antônio Azevedo; '\
                              'Vinícios Nogueira Almeida Guerra' }
    subject.stub('titulo') { 'Mania de bater' }
    subject.stub('subtitulo') { 'a punição corporal doméstica de crianças '\
                                'e adolescentes no Brasil' }
    subject.stub('traducao') { nil }
    subject.stub('edicao') { nil }
    subject.stub('local_publicacao') { 'São Paulo' }
    subject.stub('editora') { 'Iglu' }
    subject.stub('ano_publicacao') { '2001' }
    subject.stub('numero_paginas') { '386' }

    subject.referencia_abnt.should == (
      'AZEVEDO, M. A.; GUERRA, V. N. A. '\
      'Mania de bater: a punição corporal doméstica de crianças e '\
      'adolescentes no Brasil. São Paulo: Iglu, 2001. 386 p.')
  end

  it "referencia de relatorio tecnico cientifico" do
    subject.stub('tipo') { 'relatorio tecnico cientifico' }
    subject.stub('autores') { 'Ubiraci Espinelli Souza; '\
                              'Silvio Burratino Melhado' }
    subject.stub('titulo') { 'Subsídios para a avaliação'\
                             ' do custo de mão-de-obra na'\
                             ' construção civil' }
    subject.stub('local_publicacao') { 'São Paulo' }
    subject.stub('instituicao') { 'EPUSP' }
    subject.stub('ano_publicacao') { '1991' }
    subject.stub('numero_paginas') { '38' }

    subject.referencia_abnt.should == (
      'SOUZA, U. E.; MELHADO, S. B. Subsídios para a avaliação do '\
      'custo de mão-de-obra na construção civil. São Paulo: EPUSP, 1991. '\
      '38 p.')
  end

  it "referencia de imagem" do
    subject.stub('tipo') { 'imagem' }
    subject.stub('autores') { 'Alberto Gomes Pereira; Ricardo Silva' }
    subject.stub('titulo') { 'As crianças da indonésia' }
    subject.stub('instituicao') { 'Instituto Federal Fluminense' }
    subject.stub('local') { 'Campos dos Goytacazes' }

    subject.referencia_abnt.should == ('PEREIRA, A. G.; SILVA, R. As '\
                                  'crianças da indonésia. Instituto Federal '\
                                  'Fluminense, Campos dos Goytacazes.')
  end

  it "referencia de objetos de aprendizagem" do
    subject.stub('tipo') { 'objetos de aprendizagem' }
    subject.stub('autores') { 'Ariosvaldo Gomes' }
    subject.stub('titulo') { 'Viver é aprender' }
    subject.stub('instituicao') { 'Instituto Federal Fluminense' }

    subject.referencia_abnt.should == ('GOMES, A. Viver é aprender. '\
                                       'Instituto Federal Fluminense.')
  end

  it "referencia de outros conteudos" do
    subject.stub('tipo') { 'outros conteúdos' }
    subject.stub('autores') { 'Adalberto Pereira Silva' }
    subject.stub('titulo') { 'Tenho joanetes' }
    subject.stub('instituicao') { 'Instituto Federal Fluminense' }

    subject.referencia_abnt.should eql ('SILVA, A. P. Tenho joanetes. '\
                                  'Instituto Federal Fluminense.')
  end
end
