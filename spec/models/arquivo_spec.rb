# encoding: utf-8

require 'spec_helper'

describe Arquivo do
  it 'informa se é um ODT' do
    Arquivo.new(nome: 'nao_sou_odt.nao').should_not be_odt
    Arquivo.new(nome: 'eu_sou.odt').should be_odt
    Arquivo.new(nome: 'eu_nao_sou_odt').should_not be_odt
    Arquivo.new(nome: 'eu_sou.ODT').should be_odt
  end

  it 'informa se é um video' do
    arquivo = Arquivo.create nome: :nome, conteudo: create(:conteudo), mime_type: 'video/ogg'
    arquivo.video?.should be_true
    arquivo = Arquivo.create nome: :nome, conteudo: create(:conteudo), mime_type: 'text/plain'
    arquivo.video?.should be_false
  end

  it "codifica o arquivo para string base64" do
    subject.uploaded_file = ActionDispatch::Http::UploadedFile.new({
      filename: 'arquivo.rtf',
      type: 'text/rtf',
      tempfile: File.new(Rails.root + 'spec/resources/arquivo.rtf')
    })
    subject.base64.should match(/e1xydGYxXGFuc2lcYW5zaWNwZz/)
  end

  it "base_64 retorna string vazia caso não exista" do
    subject.base64.should == ""
  end

  context "extrai do arquivo do upload" do
    before(:all) do
      subject.uploaded_file = ActionDispatch::Http::UploadedFile.new({
        filename: 'arquivo.rtf',
        type: 'text/rtf',
        tempfile: File.new(Rails.root + 'spec/resources/arquivo.rtf')
      })
    end

    its(:nome) { should eq('arquivo.rtf') }
    its(:mime_type) { should eq('text/rtf') }
  end
end
