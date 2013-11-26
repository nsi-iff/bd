# encoding: UTF-8
require "spec_helper"

describe Busca do
  its(:parametros) { should be_accessible }
  its(:busca) { should be_accessible }
  its(:titulo) { should be_accessible }
  its(:descricao) { should be_accessible }

  it "trata os parâmetros de busca para a query no elasticsearch" do
    form_params = {titulo: "linguagens dinâmicas",
                    autor: "Why",
                 nome_sub_area: "Computação",
                     nome_area: "Exatas",
              instituicao: "IFF",
              tipos: ["livro", "relatorio"]}

    Busca.new(parametros: form_params).query_parametros.should eq(
      "titulo:linguagens dinâmicas "\
      "autor:Why "\
      "nome_sub_area:Computação "\
      "nome_area:Exatas "\
      "instituicao:IFF")
  end

  it "#parametros= filtra strings vazias" do
    subject.parametros = {'titulo' => 'teste', 'nome' => ''}
    subject.parametros.should eq({'titulo' => 'teste'})
  end

  it "'parametros' retorna um hash vazio caso o atributo seja nulo" do
    Busca.new.parametros.should eq({})
  end

  context "#resultados retorna conteudos buscando" do
    it "em 'conteudos' e 'arquivos'se o termo #busca existir" do
      conteudos = stub(:conteudo)
      arquivos = stub(:arquivos)
      conteudos.should_receive(:+).with(arquivos).and_return([:conteudo])
      subject.should_receive(:buscar_em_conteudos).and_return(conteudos)
      subject.should_receive(:buscar_em_arquivos).and_return(arquivos)
      subject.busca = "5Un5h1n3"
      subject.resultados.should eq([:conteudo])
    end

    it "no índice 'conteudos' se #busca for vazio" do
      conteudos = [stub(:conteudo)]
      subject.should_receive(:buscar_em_conteudos).and_return(conteudos)
      subject.should_not_receive(:buscar_em_arquivos)
      subject.parametros = {autor: 'Why'}
      subject.resultados.should eq(conteudos)
    end
  end

  it "#buscar_em_conteudos deve buscar no índice 'conteudos' do elasticsearch" do
    result = stub(:result)
    result.stub_chain(:results, :to_a).and_return([])
    Tire.should_receive('search').with('conteudos', load: true).and_return(result)
    subject.buscar_em_conteudos.should eq([])
  end

  it "#buscar_em_conteudos trata Tire::Search::SearchRequestFailed" do
    Tire.should_receive('search').with('arquivos', load: true).
      and_raise(Tire::Search::SearchRequestFailed)
    Busca.new.buscar_em_arquivos.should eq([])
  end

  it "#buscar_em_arquivos trata Tire::Search::SearchRequestFailed" do
    Tire.should_receive('search').with('conteudos', load: true).
      and_raise(Tire::Search::SearchRequestFailed)
    Busca.new.buscar_em_conteudos.should eq([])
  end

  it "#buscar_em_arquivos retornar os conteudos buscando no índice 'arquivos'" do
    result = stub(:result)
    arquivos = [stub(:arquivo, conteudo: :conteudo)]
    result.stub_chain(:results, :to_a).and_return(arquivos)
    Tire.should_receive('search').with('arquivos', load: true).and_return(result)
    subject.buscar_em_arquivos.should eq([:conteudo])
  end

  it 'serviço de mala direta' do
    Tire.criar_indices
    usuario = create(:usuario)
    busca = create(:busca, busca: "Lord", usuario: usuario, mala_direta: true)
    create(:busca, busca: "dummy", usuario: usuario, mala_direta: true)

    Timecop.travel Time.zone.now - 2.days
    livro_1 = create(:livro_publicado, titulo: 'Dracula the Lord of Shadows')
    Timecop.return
    livro_1.data_publicado.should == (Date.current - 2).strftime("%d/%m/%y")

    Timecop.travel Time.zone.now - 1.day
    livro_2 = create(:livro_publicado, titulo: 'The Lord of The Rings')
    Timecop.return
    livro_2.data_publicado.should == Date.yesterday.strftime("%d/%m/%y")

    livro_3 = create(:livro_publicado, titulo: 'The book of Lord Shang')
    livro_3.data_publicado.should == Date.current.strftime("%d/%m/%y")

    Conteudo.index.refresh

    expect {
     Busca.enviar_email_mala_direta { sleep(1) } # tempo para esperar enviar e-mail
    }.to change { ActionMailer::Base.deliveries.size }.by 1

    email = ultimo_email_enviado
    email.to.should == [usuario.email]
    email.to_s.should match(livro_2.titulo)
    email.to_s.should_not match(livro_1.titulo)
    email.to_s.should_not match(livro_3.titulo)
    email.subject.should == 'Biblioteca Digital: Novos documentos de seu interesse'
  end
end
