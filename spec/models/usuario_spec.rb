require 'spec_helper'

describe Usuario do
  describe 'abilities' do
    subject { ability }
    let(:ability) { Ability.new(usuario) }
    let(:tipos) do
      [ArtigoDeEvento, ArtigoDePeriodico, Livro,
       ObjetoDeAprendizagem, PeriodicoTecnicoCientifico,
       Relatorio, TrabalhoDeObtencaoDeGrau]
    end

    before(:each) do
      create(:papel_gestor)
      create(:papel_contribuidor)
      create(:papel_admin)
      create(:papel_instituicao_admin)
    end

    shared_examples 'adicionar e ler todos os tipos de conteudo' do
      it 'pode adicionar todos os tipos de conteudo' do
        tipos.each do |conteudo|
          should be_able_to(:create, conteudo)
        end
      end

      it 'pode acessar todos os tipos de conteudo' do
        tipos.each do |conteudo|
          should be_able_to(:read, conteudo)
        end
      end
    end

    context 'contribuidor de conteudo' do
      let(:usuario) { create(:usuario_contribuidor) }

      include_examples 'adicionar e ler todos os tipos de conteudo'
    end
  end

  context 'escrivaninha' do
    it 'retorna os conteudos do usuario que sao editaveis' do
      usuario = Usuario.new
      usuario.should_receive(:conteudos_pendentes).and_return('pendentes')
      usuario.should_receive(:conteudos_editaveis).and_return('editaveis')
      usuario.escrivaninha.should == 'editaveispendentes'
    end
  end

  context 'estante' do
    it 'retorna os conteudos aprovados do usuario' do
      usuario = Usuario.new
      usuario.should_receive(:conteudos_publicados).and_return([:publicados])
      usuario.should_receive(:favoritos).and_return([:favoritos])
      usuario.estante.should == [:publicados, :favoritos]
    end

    it 'retorna true se conteudo ou grao esta na estante' do
      usuario = create(:usuario)
      conteudo = create(:livro)
      grao = create(:grao, conteudo: conteudo)
      usuario.favoritar conteudo
      usuario.favorito?(conteudo).should be_true
      usuario.favorito?(grao).should be_false

      usuario.favoritar grao
      usuario.favorito?(grao).should be_true
    end
  end

  it { should have_valid(:email).when 'bernardo.fire@gmail.com', 'aeiou@abcd.com' }
  it { should_not have_valid(:email).when '', nil }

  it { should have_valid(:nome_completo).when 'Luke Skywalker', 'Darth Vader', 'foo 123' }
  it { should_not have_valid(:nome_completo).when nil, '' }

  it 'responde se possui um determinado papel' do
    usuario = Usuario.new
    papeis = ['gestor', 'admin', 'contribuidor'].map {|nome|
      Papel.create!(nome: nome, descricao: 'dummy')
    }
    usuario.papeis = papeis[0..1]
    usuario.should be_gestor
    usuario.should be_admin
    usuario.should_not be_contribuidor
    expect { usuario.qqcoisa? }.to raise_error(NoMethodError)
  end

  context 'cesta' do
    let(:usuario) { create(:usuario) }

    it 'permite adicionar graos' do
      usuario.cesta << stub_model(Grao)
      usuario.cesta << stub_model(Grao)
      usuario.cesta.should have(2).graos
    end
  end

  it 'pode favoritar graos' do
    grao = create(:grao)
    usuario = create(:usuario)
    Referencia.any_instance.should_receive(:valid?).twice.and_return(true)
    usuario.favoritar(grao).should be_true
    usuario.favoritos.last.should be_a(Referencia)
    usuario.favoritos.last.referenciavel.should == grao
  end

  it 'pode favoritar conteudos' do
    conteudo = create(:livro)
    usuario = create(:usuario)
    Referencia.any_instance.should_receive(:valid?).twice.and_return(true)
    usuario.favoritar(conteudo).should be_true
    usuario.favoritos.last.should be_a(Referencia)
    usuario.favoritos.last.referenciavel.should == conteudo
  end

  it 'pode remover favorito da estante' do
      usuario = create(:usuario)
      conteudo = create(:livro)
      usuario.favoritar conteudo
      usuario.remover_favorito(conteudo).should be_true
      usuario.favoritos.should be_empty
    end
end
