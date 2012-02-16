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
  end

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

  it 'arquivo ou link devem existir' do
    conteudo = Factory.build(:conteudo, arquivo: '', link: '')
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
end
