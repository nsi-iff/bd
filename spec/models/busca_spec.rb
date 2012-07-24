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
                 sub_area_nome: "Computação",
                     area_nome: "Exatas",
              instituicao: "IFF",
              tipos: ["livro", "relatorio"]}

    Busca.new(parametros: form_params).query_parametros.should eq(
      "titulo:linguagens dinâmicas "\
      "autor:Why "\
      "sub_area_nome:Computação "\
      "area_nome:Exatas "\
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
end
