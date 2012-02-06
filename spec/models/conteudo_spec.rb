require 'spec_helper'

describe Conteudo do
  it 'nao pode possuir simultaneamente arquivo e link' do
    Factory.build(:conteudo, arquivo: 'arquivo.nsi', link: '').should be_valid
    Factory.build(:conteudo, arquivo: '', link: 'http://nsi.iff.edu.br').
      should be_valid
    conteudo = Factory.build(:conteudo, arquivo: 'arquivo.nsi',
                                        link: 'http://nsi.iff.edu.br')
    conteudo.should_not be_valid
    conteudo.errors[:arquivo].should be_any
    conteudo.errors[:link].should be_any
  end
end
