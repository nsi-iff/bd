# encoding: utf-8

require 'spec_helper'

describe Estatistica do
  it 'deve retornar usuários cadastrados por ano' do
    ano = 2012
    Timecop.travel(2.years.ago) do
      3.times { Factory.create(:usuario) }
    end
    Timecop.travel(1.year.ago) do
      4.times { Factory.create(:usuario) }
    end
    2.times { Factory.create(:usuario) }

    estatisticas =  Estatistica.new(ano)
    estatisticas.numero_de_usuarios_cadastrados.should == 2

    estatisticas = Estatistica.new(ano - 2)
    estatisticas.numero_de_usuarios_cadastrados.should == 3

    estatisticas = Estatistica.new(ano - 1)
    estatisticas.numero_de_usuarios_cadastrados.should == 4
  end

  it 'deve retornar usuários cadastrados por mês' do
    ano = 2012
    mes = 12
    Timecop.travel(2.months.ago) do
      4.times { Factory.create(:usuario) }
    end
    Timecop.travel(10.months.ago) do
      9.times { Factory.create(:usuario) }
    end

    estatisticas =  Estatistica.new(ano, 2.months.ago.month)
    estatisticas.numero_de_usuarios_cadastrados.should == 4
  end

  it 'deve retornar os cinco documentos mais acessados' do
    livro = Factory.create(:livro, :numero_de_acessos => 10)
    livro.save!
    periodico = Factory.create(:periodico_tecnico_cientifico, :numero_de_acessos => 8)
    periodico.save!
    artigo_de_evento = Factory.create(:artigo_de_evento, :numero_de_acessos => 5)
    artigo_de_evento.save!
    relatorio = Factory.create(:relatorio, :numero_de_acessos => 3)
    relatorio.save!
    trabalho_obtencao_de_grau = Factory.create(:trabalho_de_obtencao_de_grau, :numero_de_acessos => 2)
    trabalho_obtencao_de_grau.save!
    estatisticas = Estatistica.new(Date.today.year)
    estatisticas.cinco_documentos_mais_acessados.length.should_not > 5
  end

  it 'deve retornar todos os documentos mais acessados' do
    livro = Factory.create(:livro, :numero_de_acessos => 12)
    livro.save!
    periodico = Factory.create(:periodico_tecnico_cientifico, :numero_de_acessos => 10)
    periodico.save!
    artigo_de_evento = Factory.create(:artigo_de_evento, :numero_de_acessos => 8)
    artigo_de_evento.save!
    relatorio = Factory.create(:relatorio, :numero_de_acessos => 5)
    relatorio.save!
    trabalho_obtencao_de_grau = Factory.create(:trabalho_de_obtencao_de_grau, :numero_de_acessos => 4)
    trabalho_obtencao_de_grau.save!
    objeto_de_aprendizagem = Factory.create(:objeto_de_aprendizagem, :numero_de_acessos => 3)
    objeto_de_aprendizagem.save!
    artigo_de_periodico = Factory.create(:artigo_de_periodico, :numero_de_acessos => 2)
    artigo_de_periodico.save!
    estatisticas = Estatistica.new(Date.today.year)
    estatisticas.documentos_mais_acessados.length.should ==  7
  end

  it 'deve retornar o percentual dos acessos por tipo de conteúdo' do
    artigo_de_evento = Factory.create(:artigo_de_evento, :numero_de_acessos => 7)
    artigo_de_evento.save!
    artigo_de_periodico = Factory.create(:artigo_de_periodico, :numero_de_acessos => 7)
    artigo_de_periodico.save!
    livro = Factory.create(:livro, :numero_de_acessos => 7)
    livro.save!
    objeto_de_aprendizagem = Factory.create(:objeto_de_aprendizagem, :numero_de_acessos => 7)
    objeto_de_aprendizagem.save!
    periodico = Factory.create(:periodico_tecnico_cientifico, :numero_de_acessos => 14)
    periodico.save!
    relatorio = Factory.create(:relatorio, :numero_de_acessos => 21)
    relatorio.save!
    trabalho_obtencao_de_grau = Factory.create(:trabalho_de_obtencao_de_grau, :numero_de_acessos => 7)
    trabalho_obtencao_de_grau.save!
    estatisticas = Estatistica.new(Date.today.year)
    estatisticas.percentual_de_acessos_por_tipo_de_conteudo.should == [["Artigo de evento", 10.0],
                                                                       ["Artigo de periodico", 10.0],
                                                                       ["Livro", 10.0], 
                                                                       ["Objeto de aprendizagem", 10.0], 
                                                                       ["Periodico tecnico cientifico", 20.0],
                                                                       ["Relatorio", 30.0],
                                                                       ["Trabalho de obtencao de grau", 10.0]]
  end

  it 'deve retornar o percentual dos acessos por subárea de conhecimento' do
    artigo_de_evento = Factory.create(:artigo_de_evento, :numero_de_acessos => 7)
    artigo_de_evento.save!
    artigo_de_periodico = Factory.create(:artigo_de_periodico, :numero_de_acessos => 7)
    artigo_de_periodico.save!
    livro = Factory.create(:livro, :numero_de_acessos => 7)
    livro.save!
    objeto_de_aprendizagem = Factory.create(:objeto_de_aprendizagem, :numero_de_acessos => 7)
    objeto_de_aprendizagem.save!
    periodico = Factory.create(:periodico_tecnico_cientifico, :numero_de_acessos => 14)
    periodico.save!
    relatorio = Factory.create(:relatorio, :numero_de_acessos => 21)
    relatorio.save!
    trabalho_obtencao_de_grau = Factory.create(:trabalho_de_obtencao_de_grau, :numero_de_acessos => 7)
    trabalho_obtencao_de_grau.save!
    estatisticas = Estatistica.new(Date.today.year)
    estatisticas.percentual_de_acessos_por_subarea_de_conhecimento.should == [
                         [SubArea.find(artigo_de_evento.sub_area_id).nome, 10.0],
                         [SubArea.find(artigo_de_periodico.sub_area_id).nome, 10.0],
                         [SubArea.find(livro.sub_area_id).nome, 10.0],
                         [SubArea.find(objeto_de_aprendizagem.sub_area_id).nome, 10.0],
                         [SubArea.find(periodico.sub_area_id).nome, 20.0],
                         [SubArea.find(relatorio.sub_area_id).nome, 30.0],
                         [SubArea.find(trabalho_obtencao_de_grau.sub_area_id).nome, 10.0]]
  end
end
