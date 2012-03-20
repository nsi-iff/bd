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
end
