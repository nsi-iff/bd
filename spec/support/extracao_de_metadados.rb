# encoding: utf-8

shared_examples_for 'conteudo que permite extração de metadados' do
  it 'permite extração de metadados' do
    described_class.new.permite_extracao_de_metadados?.should be_true
  end
end
