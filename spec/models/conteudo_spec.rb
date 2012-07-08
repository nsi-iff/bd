# encoding: utf-8

require 'spec_helper'
require 'integration/fake_nsicloudooo'

describe Conteudo do
  context 'workflow' do
    let(:conteudo) { create(:conteudo) }
    let(:cloudooo) { ServiceRegistry.cloudooo }

    it 'possui estado inicial editavel' do
      conteudo.state.should == 'editavel'
    end

    context 'editavel' do
      it 'ao ser submetido, vai para pendente' do
        expect { conteudo.submeter! }.to change { conteudo.state }.
          from('editavel').to('pendente')
      end
    end

    context 'pendente' do
      before(:each) { conteudo.submeter! }

      context 'ao aprovar' do
        context 'se granularizável' do
          before(:each) do
            conteudo.stub(:granularizavel?).and_return(true)
            conteudo.link = nil
            f = File.open(File.join(Rails.root, 'spec', 'resources',
              'manual.odt'))
            f.stub(:original_filename).and_return('anything.odt')
            f.stub(:content_type).and_return('application/vnd.oasis.opendocument.text')
            conteudo.arquivo = f
            conteudo.save!
          end

          it 'envia para granularização' do
            cloudooo.stub(:new).and_return(oo = stub)
            cloudooo.should_receive(:granulate)
            conteudo.aprovar!
          end

          it 'vai para granularizando' do
            expect { conteudo.aprovar! }.to change { conteudo.state }.
              from('pendente').to('granularizando')
          end
        end

        context 'se não granularizável' do
          before(:each) { conteudo.stub(:granularizavel?).and_return(false) }

          it 'vai para publicado' do
            expect { conteudo.aprovar! }.to change { conteudo.state }.
              from('pendente').to('publicado')
          end
        end
      end

      it 'ao devolver, vai para editável' do
        expect { conteudo.devolver! }.to change { conteudo.state }.
          from('pendente').to('editavel')
      end

      it 'ao remover, vai para removido' do
        expect {
          conteudo.remover!(motivo: 'qq um')
        }.to change { conteudo.state }.from('pendente').to('removido')
      end
    end

    context 'granularizando' do
      before :each do
        conteudo.submeter!
        conteudo.stub(:granularizavel?).and_return(true)
        conteudo.set_arquivo(Arquivo.create!(key: 'dummy_key', nome: 'file.odt'))
        conteudo.link = nil
        conteudo.aprovar!
      end

      context 'problemas na granularização' do
        it 'vai para pendente' do
          expect { conteudo.falhou_granularizacao! }.to change { conteudo.state }.
            from('granularizando').to('pendente')
        end
      end

      context 'granularização ok' do
        before(:each) { Arquivo.create!(key: '1234', conteudo: conteudo) }

        it 'vai para publicado' do
          expect {
            conteudo.granularizou!(graos: {})
          }.to change { conteudo.state }.from('granularizando').to('publicado')
        end

        it 'gera grãos' do
          conteudo.granularizou!(
            graos: { 'files' => ['9876', '5432'], 'images' => ['5678'] })
          conteudo.should have(3).graos
          conteudo.graos_arquivo.map(&:key).should =~ %w(9876 5432)
          conteudo.graos_imagem.map(&:key).should == ['5678']
        end
      end
    end

    context 'publicado' do
      before :each do
        conteudo.submeter!
        conteudo.stub(:granularizavel?).and_return(false)
        conteudo.aprovar!
      end

      it 'ao requisitar devolução, vai para editavel' do
        expect { conteudo.devolver! }.to change { conteudo.state }.
          from('publicado').to('editavel')
      end

      it 'ao recolher, vai para recolhido' do
        expect { conteudo.recolher! }.to change { conteudo.state }.
          from('publicado').to('recolhido')
      end
    end

    context 'recolhido' do
      before :each do
        conteudo.submeter!
        conteudo.stub(:granularizavel?).and_return(false)
        conteudo.aprovar!
        conteudo.recolher!
      end

      it 'ao devolver, vai para editavel' do
        expect { conteudo.devolver! }.to change { conteudo.state }.
          from('recolhido').to('editavel')
      end

      it 'ao publicar, vai para publicado' do
        expect { conteudo.publicar! }.to change { conteudo.state }.
          from('recolhido').to('publicado')
      end

      it 'ao remover, vai para removido' do
        expect {
          conteudo.remover!(motivo: 'improprio')
        }.to change { conteudo.state }.from('recolhido').to('removido')
      end
    end
  end

  context 'mudança de estado' do
    let(:conteudo) { create(:conteudo) }

    it 'armazena seu estado corrente' do
      c = create(:conteudo)
      c.submeter!
      c.state.should == 'pendente'

      c.stub(:granularizavel?).and_return(false)
      c.aprovar!
      c.state.should == 'publicado'
    end

    it 'mensagem "estado" retorna o estado corrente' do
      conteudo.estado.should == 'editavel'
      conteudo.submeter!
      conteudo.estado.should == 'pendente'
    end

    def verificar(conteudo, evento, de, para)
      tempo = Time.now
      expect {
        Timecop.freeze(tempo) do
          conteudo.send(evento)
        end
      }.to change { conteudo.mudancas_de_estado.size }.by(1)
      mudanca = conteudo.mudancas_de_estado.last
      mudanca.de.should == de
      mudanca.para.should == para
      mudanca.data_hora.should == tempo
    end

    it 'gera um objeto para a mudança de estado a cada transição' do
      verificar(conteudo, :submeter!, 'editavel', 'pendente')
      conteudo.stub(:granularizavel?).and_return(true)
      conteudo.set_arquivo(Arquivo.new(key: 'dummy', nome: 'file.odt'))
      conteudo.link = nil
      verificar(conteudo, :aprovar!, 'pendente', 'granularizando')
      verificar(conteudo, :falhou_granularizacao!, 'granularizando', 'pendente')
      verificar(conteudo, :devolver, 'pendente', 'editavel')
    end

    context 'motivo da remoção' do
      before(:each) { conteudo.submeter! }

      it 'obrigatório' do
        expect { conteudo.remover! }.to raise_error
        conteudo.remover!(motivo: 'um problema')
      end

      it 'escreve o motivo na mudança de estado' do
        conteudo.remover!(motivo: 'inadequado')
        conteudo.mudancas_de_estado.last.motivo.should == 'inadequado'
      end
    end

    context 'todas as transições para "editavel" devem destruir todos os grãos' do
      it 'pendente --> editavel' do
        conteudo.submeter!
        conteudo.should_receive(:destruir_graos)
        conteudo.devolver!
      end

      it 'publicado --> editavel' do
        conteudo.submeter!
        conteudo.stub(:granularizavel?).and_return(false)
        conteudo.aprovar!
        conteudo.should_receive(:destruir_graos)
        conteudo.devolver!
      end

      it 'recolhido --> editavel' do
        conteudo.submeter!
        conteudo.stub(:granularizavel?).and_return(false)
        conteudo.aprovar!
        conteudo.recolher!
        conteudo.should_receive(:destruir_graos)
        conteudo.devolver!
      end
    end
  end

  context 'não deve rodar código relativo a arquivos e SAM ao validar #bugfix' do
    let :conteudo do
      Conteudo.new(arquivo: stub(read: 'dummy value',
                                 original_filename: 'another dummy',
                                content_type: 'application/vnd.oasis.opendocument.text'))
    end

    it 'não deve salvar arquivo' do
      expect { conteudo.valid? }.to_not change { Arquivo.count }
    end

    it 'não deve enviar arquivo ao SAM' do
      NSISam::Client.stub(:new).and_return(sam_mock = mock)
      sam_mock.should_not_receive(:store)
      conteudo.valid?
    end
  end

  it 'fornece o nome do contribuidor' do
    conteudo = Conteudo.new(
      contribuidor: stub_model(Usuario, nome_completo: 'Linus Torvalds'))
    conteudo.nome_contribuidor.should == 'Linus Torvalds'
  end

  it 'nao pode possuir simultaneamente arquivo e link' do
    arquivo = ActionDispatch::Http::UploadedFile.new({
      filename: 'arquivo.pdf',
      type: 'text/plain',
      tempfile: File.new(Rails.root + 'spec/resources/arquivo.nsi')
    })
    build(:conteudo, arquivo: arquivo, link: '').should be_valid
    build(:conteudo, arquivo: nil,
                  link: 'http://nsi.iff.edu.br').  should be_valid
    conteudo = build(:conteudo, arquivo: arquivo,
                                        link: 'http://nsi.iff.edu.br')
    conteudo.should_not be_valid
    conteudo.errors[:arquivo].should be_any
    conteudo.errors[:link].should be_any
  end

  it 'arquivo ou link devem existir' do
    conteudo = build(:conteudo, arquivo: nil, link: '')
    conteudo.should_not be_valid
    conteudo.errors[:arquivo].should be_any
    conteudo.errors[:link].should be_any
  end

  [:livro, :artigo_de_evento, :artigo_de_periodico, :periodico_tecnico_cientifico,
   :relatorio, :trabalho_de_obtencao_de_grau].
   each do |tipo|
    it "#{tipo} deve permitir os formatos de arquivo: rtf, doc, odt, ps, pdf" do
      ['arquivo.rtf', 'arquivo.doc', 'arquivo.odt', 'arquivo.ps', 'arquivo.pdf']
      .each do |arquivo_tipo|
        arquivo = ActionDispatch::Http::UploadedFile.new({
          filename: arquivo_tipo,
          type: 'text/plain',
          tempfile: File.new(Rails.root + "spec/resources/#{arquivo_tipo}")
        })
        build(tipo, link: '',
                  arquivo: arquivo).should be_valid
      end
    end

    it "#{tipo} não deve permitir outros além de rtf, doc, odt, ps, pdf" do
      arquivo = ActionDispatch::Http::UploadedFile.new({
        filename: 'arquivo.nsi',
        type: 'text/plain',
        tempfile: File.new(Rails.root + "spec/resources/arquivo.nsi")
      })
      build(tipo, link: '',
                arquivo: arquivo).should_not be_valid
    end
   end

  it 'area deve ser a area ligada a sua subarea' do
    area = create(:area)
    subarea = create(:sub_area, area: area)
    conteudo = build(:conteudo, sub_area: subarea)

    conteudo.area.should be(area)
  end

  it 'instituicao deve ser a instituicao ligada ao usuario contribuidor' do
    usuario = create(:usuario_contribuidor)
    instituicao_usuario = usuario.campus.instituicao
    campus = create(:campus, instituicao: instituicao_usuario)
    conteudo = build(:conteudo, campus: campus)

    conteudo.campus.instituicao.should be(instituicao_usuario)
  end

  context 'atributos obrigatorios' do
    it { should_not have_valid(:titulo).when('', nil) }
    it { should_not have_valid(:sub_area).when(nil) }
#    it { should_not have_valid(:campus).when('', nil) }

    it 'deve ter pelo menos um autor' do
      subject.valid?
      subject.errors[:autores].should be_any
      subject.autores.build(nome: 'Linus', lattes: 'http://lattes.cnpq.br/1')
      subject.valid?
      subject.errors[:autores].should_not be_any
    end
  end

  context 'granularizavel' do
    let(:conteudo) { build(:conteudo) }

    it 'nao granularizavel se é um link' do
      conteudo.set_arquivo(nil)
      conteudo.link = 'um link'
      conteudo.should_not be_granularizavel
    end

    it 'por enquanto, apenas se o arquivo associado for um ODT' do
      conteudo.link = nil
      conteudo.set_arquivo(stub_model(Arquivo, odt?: false))
      conteudo.should_not be_granularizavel
      conteudo.set_arquivo(stub_model(Arquivo, odt?: true))
      conteudo.should be_granularizavel
    end
  end

  context "codifica arquivo para base 64" do
    it "retorna a string em base 64 do arquivo caso exista" do
      subject.arquivo = ActionDispatch::Http::UploadedFile.new({
        filename: 'arquivo.rtf',
        type: 'text/rtf',
        tempfile: File.new(Rails.root + 'spec/resources/arquivo.rtf')
      })
      subject.arquivo_base64.should match(/e1xydGYxXGFuc2lcYW5zaWNwZz/)
    end

    it "retorna string vazia caso o arquivo não exista" do
      subject.arquivo_base64.should == ""
    end
  end

  context 'pesquisa por meta-dados' do
    it "pesquisa no índice 'conteudos' do elasticsearch" do
      result = mock(:result).as_null_object
      Tire.should_receive('search').with('conteudos').and_return(result)
      Conteudo.search 'busca'
    end

    context 'indexação de atributos de relacionamentos' do
      before(:each) do
        subject.autores = [create(:autor, nome: '_why', lattes: 'http://lattes.cnpq.br/1234567890'),
                           create(:autor, nome: 'blix', lattes: 'http://lattes.cnpq.br/0987654321')]
        area = Area.create!(nome: 'Ciências Exatas e da Terra')
        sub_area = subject.sub_area = area.sub_areas.create!(nome: 'Ciência da Computação')
      end

      context 'dos autores' do
        let(:autores) { campos_a_serem_indexados['autores'] }

        it "deve incluir os nomes dos autores" do
          autores.first['nome'].should == '_why'
          autores.second['nome'].should == 'blix'
        end

        it "deve incluir os links dos currículos lattes dos autores" do
          autores.first['lattes'].should == 'http://lattes.cnpq.br/1234567890'
          autores.second['lattes'].should == 'http://lattes.cnpq.br/0987654321'
        end
      end

      it "deve incluir o nome da sub-área" do
        campos_a_serem_indexados['sub_area_nome'].should == 'Ciência da Computação'
      end

      it "deve incluir o nome da área da sub-área" do
        campos_a_serem_indexados['area_nome'].should == 'Ciências Exatas e da Terra'
      end
    end

    def campos_a_serem_indexados
      JSON.parse(subject.to_indexed_json)
    end
  end

  describe 'encontrar conteudo por ID SAM' do
    it 'padrão' do
      Arquivo.stub(:find_by_key).with('sinister_key').and_return(
        arquivo = stub_model(Arquivo, conteudo: conteudo = stub_model(Conteudo)))
      Conteudo.encontrar_por_id_sam('sinister_key').should == conteudo
    end

    it 'retorna nil caso não exista' do
      Arquivo.stub(:find_by_key).and_return(nil)
      Conteudo.encontrar_por_id_sam('dummy value').should be_nil
    end
  end

  describe 'retorna graos por tipo' do
    let(:conteudo) do
      conteudo = Conteudo.new
      conteudo.graos << @grao1 = stub_model(Grao, imagem?: true, arquivo?: false)
      conteudo.graos << @grao2 = stub_model(Grao, imagem?: false, arquivo?: true)
      conteudo.graos << @grao3 = stub_model(Grao, imagem?: false, arquivo?: true)
      conteudo
    end

    it 'graos imagem' do
      conteudo.graos_imagem.should == [@grao1]
    end

    it 'graos arquivo' do
      conteudo.graos_arquivo.should =~ [@grao2, @grao3]
    end
  end

  it 'retorna os conteudos pendentes para uma dada instituicao' do
    meu_campus, outro_campus = create(:campus), create(:campus)
    outro_campus_da_minha_instituicao = create(:campus, instituicao: meu_campus.instituicao)
    usuario_gestor = create(:usuario_gestor, campus: meu_campus)

    outro_artigo_pendente = create(:artigo_de_evento, campus: outro_campus)
    outro_artigo_pendente.submeter!

    meu_artigo_pendente = create(:artigo_de_evento, campus: meu_campus)
    meu_artigo_pendente.submeter!

    meu_outro_artigo_pendente = create(:artigo_de_evento, campus: outro_campus_da_minha_instituicao)
    meu_outro_artigo_pendente.submeter!

    editavel = create(:artigo_de_evento, campus: meu_campus)
    aprovado = create(:relatorio, campus: meu_campus)
    aprovado.submeter!
    aprovado.aprovar!

    usuario_gestor.lista_de_revisao.should have(2).itens
    usuario_gestor.lista_de_revisao.should include meu_artigo_pendente, meu_outro_artigo_pendente
  end

  it 'retorna a extensão do arquivo enviado' do
    meu_arquivo = create(:livro)
    meu_arquivo.set_arquivo(Arquivo.new(nome: 'file.doc'))
    meu_arquivo.extensao.should == "doc"
  end
end
