# encoding: utf-8

require 'spec_helper'

describe ObjetoDeAprendizagem do
  it 'fornece os nomes dos eixos temáticos' do
    objeto = create(:objeto_de_aprendizagem)
    objeto.nomes_dos_eixos_tematicos.should be_nil
    %w(Agricultura Artes Filosofia).each do |nome_eixo|
      objeto.cursos << create(:curso,
        eixo_tematico: create(:eixo_tematico, nome: nome_eixo))
    end
    objeto.reload.nomes_dos_eixos_tematicos.should == 'Agricultura, Artes e Filosofia'
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

  it 'fornece o estado da flag pronatec' do
    subject.pronatec.should be_nil
    subject.pronatec = true
    subject.pronatec.should == true
  end

  its(:tipo_de_arquivo_importa?) { should be_false }

  it "preenche de volta a associação 'conteudo' do arquivo em #arquivo_attributes=" do
    subject.arquivo_attributes=(params = {})
    params.fetch(:conteudo).should eq(subject)
    subject.arquivo.conteudo.should eq(subject)
  end

  it 'tipo de arquivo não importa' do
    upload = ActionDispatch::Http::UploadedFile.new({
      filename: 'arquivo.nsi',
      type: 'text/plain',
      tempfile: File.new(Rails.root + "spec/resources/arquivo.nsi")
    })
    conteudo = build(:objeto_de_aprendizagem, link: '',
     arquivo_attributes: {uploaded_file: upload})
    conteudo.should be_valid
  end
end
