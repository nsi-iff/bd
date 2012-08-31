# encoding: utf-8

require 'spec_helper'

describe Arquivo do
  it 'informa se é um ODT' do
    subject.nome = 'eu_sou.odt'; subject.should be_odt
    subject.nome = 'eu_sou.ODT'; subject.should be_odt
    subject.nome = 'nao_sou_odt.nao'; subject.should_not be_odt
    subject.nome = 'eu_nao_sou_odt'; subject.should_not be_odt
  end

  it 'informa mimetype' do
    subject.uploaded_file = ActionDispatch::Http::UploadedFile.new({
      tempfile: File.new(Rails.root + 'spec/resources/arquivo.pdf')
    })
    subject.mime_type.should == "application/pdf"
  end

  it 'verifica mimetype para um upload_video_ogg' do
    subject.uploaded_file = ActionDispatch::Http::UploadedFile.new({
      tempfile: File.new(Rails.root + 'spec/resources/video.ogg')
    })
    subject.mime_type.should == "video/x-theora+ogg"
  end

  it 'verifica mimetype para um upload_audio_ogg' do
    subject.uploaded_file = ActionDispatch::Http::UploadedFile.new({
      tempfile: File.new(Rails.root + 'spec/resources/audio.ogg')
    })
    subject.mime_type.should == "audio/x-vorbis+ogg"
  end

  it 'informa se é um video' do
    subject.mime_type = 'video/ogg'
    subject.should be_video
    subject.mime_type = 'text/plain'
    subject.should_not be_video
  end

  it "codifica o arquivo para string base64" do
    subject.uploaded_file = ActionDispatch::Http::UploadedFile.new({
      filename: 'arquivo.rtf',
      type: 'text/rtf',
      tempfile: File.new(Rails.root + 'spec/resources/arquivo.rtf')
    })
    subject.content_base64.should match(/e1xydGYxXGFuc2lcYW5zaWNwZz/)
  end

  it "quando arquivo não existir #content_base64 retorna string vazia" do
    subject.content_base64.should == ""
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
    its(:mime_type) { should eq('application/rtf') }
  end

  context "quando #conteudo existe" do
    it "pergunta ao conteudo se o tipo de arquivo importa" do
      arquivo = build(:arquivo, conteudo: stub_model(Conteudo,
        tipo_de_arquivo_importa?: true))
      arquivo.tipo_importa?.should be_true

      arquivo = build(:arquivo, conteudo: stub_model(Conteudo,
        tipo_de_arquivo_importa?: false))
      arquivo.tipo_importa?.should be_false
    end

    context "quando o tipo de arquivo importar para o conteúdo" do
      conteudos.each do |tipo|
        it "#{tipo} permite os formatos de arquivo: rtf, doc, odt, ps, pdf" do
          formatos_de_arquivo.each do |formato|
            upload = ActionDispatch::Http::UploadedFile.new({
              filename: "arquivo.#{formato}",
              type: 'text/plain',
              tempfile: File.new(Rails.root + "spec/resources/arquivo.#{formato}")
            })
            Arquivo.new(uploaded_file: upload).should be_valid
          end
        end

        it "#{tipo} não deve permitir outros além de rtf, doc, odt, ps, pdf" do
          upload = ActionDispatch::Http::UploadedFile.new({
            filename: 'arquivo.nsi',
            type: 'text/plain',
            tempfile: File.new(Rails.root + "spec/resources/arquivo.nsi")
          })
          Arquivo.new(uploaded_file: upload).should_not be_valid
        end
      end
    end

    context "quando o tipo de arquivo não importar para o conteúdo" do
      it "deve aceitar qualquer formato" do
        upload = ActionDispatch::Http::UploadedFile.new({
          filename: 'arquivo.nsi',
          type: 'text/plain',
          tempfile: File.new(Rails.root + "spec/resources/arquivo.nsi")
        })
        arquivo = build(:arquivo, conteudo: stub_model(Conteudo,
          tipo_de_arquivo_importa?: false, uploaded_file: upload))
        arquivo.should be_valid
      end
    end
  end

  context "se o conteúdo não existe" do
    it "deve validar o tipo" do
      arquivo = build(:arquivo, conteudo: nil)
      arquivo.tipo_importa?.should be_true
    end
  end

  it "quando for criado, envia o arquivo ao sam" do
    upload = ActionDispatch::Http::UploadedFile.new({
      filename: "arquivo.rtf",
      type: 'text/plain',
      tempfile: File.new(Rails.root + "spec/resources/arquivo.rtf")
    })
    arquivo = build(:arquivo, uploaded_file: upload)
    ServiceRegistry.sam.should_receive(:store).with(file: arquivo.content_base64).
      and_return("key" => "123")
    arquivo.save
    arquivo.key.should eq("123")
  end

  context "#mapping do elasticsearch" do
    def mapping(key = nil)
      key ? subject.class.mapping.fetch(key) : mapping
    end

    it "não deve indexar o campo 'id'" do
      mapping(:id).fetch(:index).should eq(:not_analyzed)
    end

    it "deve mapear 'content_base64' como 'attachment' no elasticsearch" do
      mapping(:content_base64).should eq(type: :attachment)
    end
  end

  it "#content_base64 deve ser inserido no #to_indexed_json" do
    upload = ActionDispatch::Http::UploadedFile.new({
      filename: "arquivo.rtf",
      type: 'text/plain',
      tempfile: File.new(Rails.root + "spec/resources/arquivo.rtf")
    })
    subject.uploaded_file = upload
    upload.rewind
    JSON.parse(subject.to_indexed_json).fetch("content_base64").should eq(
      Base64.encode64(upload.tempfile.read)
    )
  end

  it 'retorna a extensão do arquivo enviado' do
    arquivo = build(:arquivo, uploaded_file: ActionDispatch::Http::UploadedFile.new({
      filename: 'arquivo.doc',
      type: 'application/msword',
      tempfile: File.new(Rails.root + 'spec/resources/arquivo.doc')
    }))
    arquivo.extensao.should eq("doc")
  end

  it 'possui chave no sam para o seu thumbnail' do
    arquivo = build(:arquivo)
    arquivo.should_receive(:thumbnail).and_return('chave do sam')
    arquivo.thumbnail.should == 'chave do sam'
  end
end
