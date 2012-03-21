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

end
