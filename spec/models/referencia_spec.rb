require 'spec_helper'

describe Referencia do
  it { should_not have_valid(:referenciavel).when nil }
  it { should_not have_valid(:usuario).when nil }
  it { should_not have_valid(:abnt).when nil }

  it 'deve salvar refencia abnt do referenciavel quando criado' do
    conteudo = create(:artigo_de_periodico)
    grao = create(:grao, conteudo: conteudo)
    referencia = create(:referencia, referenciavel: grao)
    referencia.should be_valid
    referencia.abnt.should == grao.referencia_abnt
  end

  it 'nao deve exigir referenciavel se referencia ja existir' do
    referencia = create(:referencia)
    referencia.referenciavel = nil
    referencia.should be_valid
  end

  it 'deve salvar o tipo do grao se referenciavel for Grao' do
    conteudo = create(:artigo_de_periodico)
    grao = create(:grao, conteudo: conteudo)
    referencia = create(:referencia, referenciavel: grao)
    referencia.tipo_do_grao.should == grao.tipo
  end
end
