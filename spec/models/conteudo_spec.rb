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
            f = ActionDispatch::Http::UploadedFile.new({
                filename: 'arquivo.pdf',
                type: 'text/plain',
                tempfile: File.new(Rails.root + 'spec/resources/manual.odt')
            })
            # f = File.open(File.join(Rails.root, 'spec', 'resources',
              # 'manual.odt'))
            # f.stub(:original_filename).and_return('anything.odt')
            # f.stub(:content_type).and_return('application/vnd.oasis.opendocument.text')
            conteudo.arquivo = f
            conteudo.save!
          end

          it 'envia para granularização' do
            cloudooo.stub(:new).and_return(oo = double)
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

        it 'vai para recolhido' do
          expect { conteudo.recolher! }.to change { conteudo.state }.
            from('pendente').to('recolhido')
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
        conteudo.arquivo = build(:arquivo)
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
        before(:each) { create(:arquivo) }

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

        it 'salva chave do thumbnail no arquivo' do
          conteudo.granularizou!(graos: {}, thumbnail: 'chave do sam')
          conteudo.arquivo.thumbnail_key.should == 'chave do sam'
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

      it 'ao retornar para revisão, vai para pendente' do
        expect {
          conteudo.retornar_para_revisao!
        }.to change { conteudo.state }.from('recolhido').to('pendente')
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
      tempo_inicio = Time.now
      expect {
        conteudo.send(evento)
      }.to change { conteudo.mudancas_de_estado.size }.by(1)
      tempo_fim = Time.now
      mudanca = conteudo.mudancas_de_estado.last
      mudanca.de.should == de
      mudanca.para.should == para
      mudanca.data_hora.should satisfy {|data_hora|
        tempo_inicio < data_hora && data_hora < tempo_fim }
    end

    it 'gera um objeto para a mudança de estado a cada transição' do
      verificar(conteudo, :submeter!, 'editavel', 'pendente')
      conteudo.stub(:granularizavel?).and_return(true)
      conteudo.arquivo = build(:arquivo)
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

      it 'recolhido --> editavel' do
        conteudo.submeter!
        conteudo.stub(:granularizavel?).and_return(false)
        conteudo.aprovar!
        conteudo.recolher!
        conteudo.should_receive(:destruir_graos)
        conteudo.devolver!
      end
    end

    context 'transições de publicado para qualquer outro estado devem destruir todos os grãos' do
      it 'publicado --> pendente' do
        conteudo.submeter!
        conteudo.stub(:granularizavel?).and_return(false)
        conteudo.aprovar!
        conteudo.should_receive(:destruir_graos)
        conteudo.retornar_para_revisao!
      end

      it 'publicado --> editavel' do
        conteudo.submeter!
        conteudo.stub(:granularizavel?).and_return(false)
        conteudo.aprovar!
        conteudo.should_receive(:destruir_graos)
        conteudo.devolver!
      end

      it 'publicado --> recolhido' do
        conteudo.submeter!
        conteudo.stub(:granularizavel?).and_return(false)
        conteudo.aprovar!
        conteudo.should_receive(:destruir_graos)
        conteudo.recolher!
      end
    end
  end

  context 'não deve rodar código relativo a arquivos e SAM ao validar #bugfix' do
    let :conteudo do
      Conteudo.new(arquivo: ActionDispatch::Http::UploadedFile.new({
                filename: 'arquivo.pdf',
                type: 'text/plain',
                tempfile: File.new(Rails.root + 'spec/resources/manual.odt')
            }))
    end

    it 'não deve salvar arquivo' do
      expect { conteudo.valid? }.to_not change { Arquivo.count }
    end

    it 'não deve enviar arquivo ao SAM' do
      NSISam::Client.stub(:new).and_return(sam_mock = double)
      sam_mock.should_not_receive(:store)
      conteudo.valid?
    end
  end

  it 'fornece o nome do contribuidor' do
    conteudo = Conteudo.new(
      contribuidor: stub_model(Usuario, nome_completo: 'Linus Torvalds'))
    conteudo.nome_contribuidor.should == 'Linus Torvalds'
  end

  it 'não pode possuir simultaneamente arquivo e link' do
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

  it "o arquivo deve ser de um tipo válido" do
    conteudo = build(:conteudo, link: nil,
                                arquivo: stub_model(Arquivo, valid?: true, destroy: true))
    conteudo.should be_valid
    conteudo.arquivo = stub_model(Arquivo, valid?: false)
    conteudo.should_not be_valid
    conteudo.errors[:arquivo].should be_any
  end

  it 'link devem ser válido' do
    build(:conteudo, arquivo: nil,
                  link: 'http://nsi.iff.edu.br').  should be_valid
    build(:conteudo, arquivo: nil,
                  link: 'abcde').  should_not be_valid
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
    let(:conteudo) { create(:livro_pendente) }

    it { conteudo.should_not have_valid(:titulo).when('', nil) }
    it { conteudo.should_not have_valid(:sub_area).when(nil) }
#    it { should_not have_valid(:campus).when('', nil) }

    it 'deve ter pelo menos um autor' do
      conteudo.autores.delete_all
      conteudo.valid?
      conteudo.errors[:autores].should be_any
      conteudo.autores.build(nome: 'Linus', lattes: 'http://lattes.cnpq.br/1')
      conteudo.valid?
      conteudo.errors[:autores].should_not be_any
    end
  end

  context 'granularizavel' do
    let(:conteudo) { build(:conteudo) }

    it 'nao granularizavel se é um link' do
      conteudo.arquivo = nil
      conteudo.link = 'um link'
      conteudo.should_not be_granularizavel
    end

    it 'arquivo deve ser granularizavel se for odt ou video' do
      conteudo.link = nil
      conteudo.arquivo = stub_model(Arquivo, odt?: false, video?: false, destroy: true)
      conteudo.should_not be_granularizavel
      conteudo.arquivo = stub_model(Arquivo, odt?: true, video?: true)
      conteudo.should be_granularizavel
    end
  end

  context 'pesquisa por meta-dados' do
    it "retorna os resultados de uma busca" do
      Busca.should_receive(:new).with(busca: 'busca') {
        double(:result).as_null_object }
      Conteudo.search 'busca'
    end

    it "pesquisa no índice 'conteudos' e 'arquivos' do elasticsearch" do
      result = double(:result, results: [])
      Tire.should_receive('search').with('conteudos', {load: true}).and_return(result)
      Tire.should_receive('search').with('arquivos', {load: true}).and_return(result)
      Conteudo.search 'busca'
    end

    it "#search retorna a soma das buscas em 'arquivos' e 'conteudos'" do
      result_conteudos = double(:conteudos, results: [:conteudos])
      result_arquivos = double(:arquivos, results: [double(conteudo: :arquivos)])
      Tire.should_receive('search').with('conteudos', {load: true}).and_return(result_conteudos)
      Tire.should_receive('search').with('arquivos', {load: true}).and_return(result_arquivos)
      Conteudo.search('busca').should == [:conteudos, :arquivos]
    end

    context 'indexação de atributos de relacionamentos' do
      subject { create(:conteudo) }

      before do
        subject.autores = [create(:autor, nome: '_why', lattes: 'http://lattes.cnpq.br/1234567890'),
                           create(:autor, nome: 'blix', lattes: 'http://lattes.cnpq.br/0987654321')]
        area = Area.create!(nome: 'Ciências Exatas e da Terra')
        subject.sub_area = area.sub_areas.create!(nome: 'Ciência da Computação')
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
        campos_a_serem_indexados['nome_sub_area'].should == 'Ciência da Computação'
      end

      it "deve incluir o nome da área da sub-área" do
        campos_a_serem_indexados['nome_area'].should == 'Ciências Exatas e da Terra'
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

  it "#extensao é delegada para o #arquivo" do
    subject.arquivo = stub_model(Arquivo, :extensao => "odt")
    subject.extensao.should eq("odt")
  end

  it "#extensao retorna nil caso #arquivo não exista" do
    subject.arquivo.should be_nil
    subject.extensao.should be_nil
  end

  it "thumbnail é delegado para o #arquivo" do
    subject.arquivo = stub_model(Arquivo, :thumbnail => "thumb")
    subject.thumbnail.should eq("thumb")
  end

  it "#thumbnail retorna nil caso #arquivo não exista" do
    subject.arquivo.should be_nil
    subject.thumbnail.should be_nil
  end

  context "retorna nome da" do
    subject do
      create(:conteudo,
        campus: stub_model(Campus, nome_instituicao: "IFF"),
        sub_area: stub_model(SubArea, nome: "Física", nome_area: "Ciências"))
    end

    its(:nome_area) { should eq("Ciências") }
    its(:nome_sub_area) { should eq("Física") }
    its(:nome_instituicao) { should eq("IFF") }
  end

  it "destrói os grãos de um conteúdo" do
    conteudo = create(:livro_publicado)
    grao = create(:grao)
    grao.should_receive(:deleta_do_sam).and_return(true)
    conteudo.graos << grao

    conteudo.graos.should_not == []
    Grao.all.should_not == []

    conteudo.destruir_graos

    conteudo.graos.should == []
    Grao.all.should == []
  end

  it "destrói os grãos quando destruir o conteúdo" do
    conteudo = create(:livro_publicado)
    grao = create(:grao)
    grao.should_receive(:deleta_do_sam).and_return(true)
    conteudo.graos << grao

    conteudo.graos.should_not == []
    Grao.all.should_not == []

    conteudo.destroy

    conteudo.graos.should == []
    Grao.all.should == []
  end

  it 'disponivel para download quando publicado E com arquivo' do
    create(:livro_publicado).should_not be_disponivel_para_download
    create(:livro_pendente, arquivo_para_conteudo(:odt)).
      should_not be_disponivel_para_download
    create(:livro_publicado, arquivo_para_conteudo(:odt)).
      should_not be_disponivel_para_download
  end

  it "#arquivo_attributes= cria um arquivo com os parametros recebidos" do
    params = {attrs: 'foo'}
    subject.should_receive(:build_arquivo).with(params)
    subject.arquivo_attributes = params
  end

  context "quanto atualizado" do
    let(:conteudo) { create(:conteudo, arquivo: create(:arquivo), link: '') }

    it "não salva automaticamente o arquivo" do
      conteudo.arquivo.should_not_receive(:save)
      conteudo.save
    end

    it "salva o arquivo se necessário, caso exista" do
      expect { create(:conteudo) }.to_not raise_error
      conteudo.arquivo.should_receive(:salvar_se_necessario)
      conteudo.save
    end
  end

  it "quando destruído também destroi arquivo" do
    conteudo = create(:relatorio, arquivo: create(:arquivo), link: '')
    conteudo.arquivo.should_receive(:deleta_do_sam).and_return(true)
    conteudo.destroy
    expect { conteudo.arquivo.reload }.to raise_error(ActiveRecord::RecordNotFound)
  end

  it 'não permite extração de metadados por default' do
    Conteudo.new.permite_extracao_de_metadados?.should be_false
  end
end
