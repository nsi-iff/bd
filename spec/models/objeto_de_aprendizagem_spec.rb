# encoding: utf-8

require 'spec_helper'

describe ObjetoDeAprendizagem do
  it 'fornece os nomes dos eixos temáticos' do
    subject.nomes_dos_eixos_tematicos.should be_nil
    %w(Agricultura Artes Filosofia).each do |nome_eixo|
      subject.eixos_tematicos << stub_model(EixoTematico, nome: nome_eixo)
    end
    subject.nomes_dos_eixos_tematicos.should == 'Agricultura, Artes e Filosofia'
  end

  it 'fornece os nomes das novas tags' do
    subject.nomes_das_novas_tags.should be_nil
    subject.novas_tags = "Agricultura\nArtes\nFilosofia"
    subject.nomes_das_novas_tags.should == 'Agricultura, Artes e Filosofia'
  end

  it 'fornece a descricao do idioma' do
    subject.descricao_idioma.should be_nil
    subject.idioma = stub_model(Idioma, descricao: 'Português (Brasil)')
    subject.descricao_idioma.should == 'Português (Brasil)'
  end

  it 'tipo de arquivo não importa' do
    arquivo = ActionDispatch::Http::UploadedFile.new({
      filename: 'arquivo.nsi',
      type: 'text/plain',
      tempfile: File.new(Rails.root + "spec/resources/arquivo.nsi")
    })
    build(:objeto_de_aprendizagem, link: '',
                  arquivo: arquivo).should be_valid
  end

end
