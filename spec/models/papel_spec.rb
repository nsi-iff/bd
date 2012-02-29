# encoding: utf-8

require 'spec_helper'

describe Papel do
  describe 'obter papel a partir do nome' do
    it 'retorna o papel' do
      ['admin', 'gestor', 'qq_um'].each do |nome|
        papel = Papel.create!(nome: nome, descricao: 'dummy')
        Papel.send(nome).should == papel
      end
    end

    it 'dispara NoMethodError para nomes que não existem' do
      expect { Papel.gestor_do_universo }.to raise_error(NoMethodError)
    end
  end
end

