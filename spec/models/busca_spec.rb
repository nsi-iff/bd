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

  it "set de 'parametros' filtra strings vazias" do
    subject.parametros = {'titulo' => 'teste', 'nome' => ''}
    subject.parametros.should eq({'titulo' => 'teste'})
  end

  it "'parametros' retorna um hash vazio caso o atributo seja nulo" do
    Busca.new.parametros.should eq({})
  end
end
