#encoding: utf-8

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
      let(:ability) { Ability.new(usuario) }

      include_examples 'adicionar e ler todos os tipos de conteudo'

      it 'apenas dono pode ver conteudo editável' do
        conteudo = build(:livro_editavel, contribuidor: usuario)
        outro_conteudo = build(:livro_editavel)
        ability.should be_able_to(:read, conteudo)
        ability.should_not be_able_to(:read, outro_conteudo)
      end
      
      context 'só pode adicionar conteúdo se pertence a algum instituto' do
        it 'unidade' do
          usuario.pode_adicionar_conteudo?.should be_true
          usuario.update_attribute(:campus, nil)
          usuario.pode_adicionar_conteudo?.should be_false
        end
        
        it 'ability' do
          ability.should be_able_to :create, Conteudo
          usuario = create(:usuario_contribuidor)
          usuario.stub(:pode_adicionar_conteudo?).and_return(false)
          Ability.new(usuario).should_not be_able_to :create, Conteudo
        end
      end
    end

    context 'gestor' do
      let(:usuario) { create(:usuario_gestor) }

      context 'aprovar' do
        let(:conteudo) { stub_model(Conteudo) }

        it 'conteúdos da própria instituição são permitidos' do
          gestor = stub_model(Usuario, gestor?: true)
          gestor.stub(:mesma_instituicao?).with(conteudo).and_return(true)
          Ability.new(gestor).should be_able_to(:aprovar, conteudo)
        end

        it 'conteúdos de instituição diferentes não são permitidos' do
          gestor = stub_model(Usuario, gestor?: true)
          gestor.stub(:mesma_instituicao?).with(conteudo).and_return(false)
          Ability.new(gestor).should_not be_able_to(:aprovar, conteudo)
        end
      end

      context 'devolver' do
        let(:conteudo) { FactoryGirl.create(:livro) }

        it 'somente conteúdos de sua própria instituição' do
          gestor = stub_model(Usuario, gestor?: true)
          gestor.stub(:mesma_instituicao?).with(conteudo).and_return(true)
          conteudo.submeter!
          Ability.new(gestor).should be_able_to(:devolver, conteudo)
        end

        it 'conteúdos de instituições diferentes não são permitidos' do
          gestor = stub_model(Usuario, gestor?: true)
          gestor.stub(:mesma_instituicao?).with(conteudo).and_return(false)
          conteudo.submeter!
          Ability.new(gestor).should_not be_able_to(:devolver, conteudo)
        end
      end

      context 'recolher' do
        let(:conteudo) { FactoryGirl.create(:livro) }

        it 'somente conteúdos de sua própria instituição' do
          gestor = stub_model(Usuario, gestor?: true)
          gestor.stub(:mesma_instituicao?).with(conteudo).and_return(true)
          conteudo.submeter!
          conteudo.aprovar!
          Ability.new(gestor).should be_able_to(:recolher, conteudo)
        end
      end

      context 'retornar para revisão' do
        let(:conteudo) { stub_model(Conteudo) }

        it 'somente conteúdos de sua própria instituição' do
          autorizado = stub_model(Usuario, gestor?: true)
          autorizado.stub(:mesma_instituicao?).with(conteudo).and_return(true)
          Ability.new(autorizado).should be_able_to(:retornar_para_revisao, conteudo)

          desautorizado = stub_model(Usuario, gestor?: true)
          desautorizado.stub(:mesma_instituicao?).and_return(false)
          Ability.new(desautorizado).should_not be_able_to(:retornar_para_revisao, conteudo)
        end

        it 'conteúdos de instituições diferentes não são permitidos' do
          nao_gestor = stub_model(Usuario, gestor?: false)
          nao_gestor.stub(:mesma_instituicao?).with(conteudo).and_return(true)
          Ability.new(nao_gestor).should_not be_able_to(:retornar_para_revisao, conteudo)
        end
      end

      it 'somente gestor pode acessar lista de revisão' do
        gestor = stub_model(Usuario, gestor?: true)
        Ability.new(gestor).should be_able_to(:ter_lista_de_revisao, Usuario)
        Ability.new(gestor).should be_able_to(:lista_de_revisao, Usuario)

        nao_gestor = stub_model(Usuario, gestor?: false)
        Ability.new(nao_gestor).should_not be_able_to(:ter_lista_de_revisao, Usuario)
        Ability.new(nao_gestor).should_not be_able_to(:lista_de_revisao, Usuario)
      end
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
      referencia_conteudo = create(:livro).referencia
      referencia_grao = create(:grao).referencia
      usuario.favoritar(referencia_conteudo)
      usuario.favorito?(referencia_conteudo).should be_true
      usuario.favorito?(referencia_grao).should be_false

      usuario.favoritar(referencia_grao)
      usuario.favorito?(referencia_grao).should be_true
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
      usuario.cesta << stub_model(Referencia)
      usuario.cesta << stub_model(Referencia)
      usuario.cesta.should have(2).referencias
    end
  end

  it 'pode favoritar graos' do
    grao = create(:grao)
    usuario = create(:usuario)
    Referencia.any_instance.should_receive(:valid?).twice.and_return(true)
    usuario.favoritar(grao.referencia).should be_true
    usuario.favoritos.last.should be_a(Referencia)
    usuario.favoritos.last.referenciavel.should == grao
  end

  it 'pode favoritar conteudos' do
    conteudo = create(:livro)
    referencia_conteudo = conteudo.referencia
    usuario = create(:usuario)
    Referencia.any_instance.stub(:valid?).and_return(true)
    usuario.favoritar(referencia_conteudo).should be_true
    usuario.favoritos.last.should be_a(Referencia)
    usuario.favoritos.last.referenciavel.should == conteudo
  end

  it 'pode remover favorito da estante' do
      usuario = create(:usuario)
      referencia_conteudo = create(:livro).referencia
      usuario.favoritar(referencia_conteudo)
      usuario.remover_favorito(referencia_conteudo).should be_true
      usuario.favoritos.should be_empty
    end

  context 'lista de revisão' do
    it 'solicita a Conteudo os conteudos pendentes em sua instituicao' do
      usuario = create(:usuario_gestor)
      Conteudo.should_receive(:pendentes_da_instituicao).
               with(usuario.campus.instituicao).
               and_return(:isso)
      usuario.lista_de_revisao.should == :isso
    end
  end

  it 'usuario pode trocar instituicao de origem' do
    meu_campus, outro_campus = create(:campus), create(:campus)
    usuario = create(:usuario, campus: meu_campus)
    usuario.trocar_campus outro_campus
    usuario.campus.instituicao.should == outro_campus.instituicao
  end

  context 'gerenciamento de usuários' do
    it 'busca por nome' do
      Papel.criar_todos
      usuario = create(:usuario)
      usuario.papeis << Papel.all
      a = Usuario.buscar_por_nome(usuario.nome_completo.upcase, usuario)
      a.size.should == 1
    end
  end
end
