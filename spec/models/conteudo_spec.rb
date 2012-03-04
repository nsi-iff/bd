# encoding: utf-8

require 'spec_helper'

describe Conteudo do
  context 'workflow' do
    let(:conteudo) { Factory.create(:conteudo) }

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
          before(:each) { conteudo.stub(:granularizavel?).and_return(true) }

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
        conteudo.aprovar!
      end

      context 'problemas na granularização' do
        before(:each) { conteudo.stub(:granularizado?).and_return(false) }

        it 'vai para pendente' do
          expect { conteudo.granularizou! }.to change { conteudo.state }.
            from('granularizando').to('pendente')
        end
      end

      context 'granularização ok' do
        before(:each) { conteudo.stub(:granularizado?).and_return(true) }

        it 'vai para publicado' do
          expect { conteudo.granularizou! }.to change { conteudo.state }.
            from('granularizando').to('publicado')
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
    let(:conteudo) { Factory.create(:conteudo) }

    it 'armazena seu estado corrente' do
      c = Factory.create(:conteudo)
      c.submeter!
      c = Conteudo.find(c.id)
      c.state.should == 'pendente'

      c.stub(:granularizavel?).and_return(false)
      c.aprovar!
      c = Conteudo.find(c .id)
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
      verificar(conteudo, :aprovar!, 'pendente', 'granularizando')
      conteudo.stub(:granularizado?).and_return(false)
      verificar(conteudo, :granularizou!, 'granularizando', 'pendente')
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

  it 'nao pode possuir simultaneamente arquivo e link' do
    arquivo = ActionDispatch::Http::UploadedFile.new({
      filename: 'arquivo.nsi',
      type: 'text/plain',
      tempfile: File.new(Rails.root + 'spec/resources/arquivo.nsi')
    })
    Factory.build(:conteudo, arquivo: arquivo, link: '').should be_valid
    Factory.build(:conteudo, arquivo: nil, link: 'http://nsi.iff.edu.br').
      should be_valid
    conteudo = Factory.build(:conteudo, arquivo: arquivo,
                                        link: 'http://nsi.iff.edu.br')
    conteudo.should_not be_valid
    conteudo.errors[:arquivo].should be_any
    conteudo.errors[:link].should be_any
  end

  it 'arquivo ou link devem existir' do
    conteudo = Factory.build(:conteudo, arquivo: nil, link: '')
    conteudo.should_not be_valid
    conteudo.errors[:arquivo].should be_any
    conteudo.errors[:link].should be_any
  end

  it 'area deve ser a area ligada a sua subarea' do
    area = Factory.create(:area)
    subarea = Factory.create(:sub_area, area: area)
    conteudo = Factory.build(:conteudo, sub_area: subarea)

    conteudo.area.should be(area)
  end

  context 'atributos obrigatorios' do
    it { should_not have_valid(:titulo).when('', nil) }
    it { should_not have_valid(:sub_area).when(nil) }
    it { should_not have_valid(:campus).when('', nil) }

    it 'deve ter pelo menos um autor' do
      subject.valid?
      subject.errors[:autores].should be_any
      subject.autores.build(nome: 'Linus', lattes: 'http://lattes.cnpq.br/1')
      subject.valid?
      subject.errors[:autores].should_not be_any
    end
  end

  context 'pesquisa por meta-dados' do
    it "pesquisa no índice 'conteudos' do elasticsearch" do
      result = mock(:result).as_null_object
      Tire.should_receive('search').with('conteudos').and_return(result)
      Conteudo.search 'busca'
    end

    context 'indexação de atributos de relacionamentos' do
      before(:all) do
        subject.autores = [Factory(:autor, nome: '_why', lattes: 'http://lattes.cnpq.br/1234567890'),
                           Factory(:autor, nome: 'blix', lattes: 'http://lattes.cnpq.br/0987654321')]
        Area.destroy_all
        SubArea.destroy_all
        area = Area.create(nome: 'Ciências Exatas e da Terra')
        subject.sub_area = area.sub_areas.create(nome: 'Ciência da Computação')
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
        campos_a_serem_indexados['sub_area']['nome'].should == 'Ciência da Computação'
      end

      it "deve incluir o nome da área da sub-área" do
        campos_a_serem_indexados['sub_area']['area']['nome'].should == 'Ciências Exatas e da Terra'
      end
    end

    def campos_a_serem_indexados
      JSON.parse(subject.to_indexed_json)
    end
  end
end
