# encoding: UTF-8
require "spec_helper"

describe Busca do
  it "trata os parâmetros de busca para a query no elasticsearch" do
    form_params = {titulo: "linguagens dinâmicas",
                    autor: "Why",
                 sub_area: "Computação",
                     area: "Exatas",
              instituicao: "IFF"}

    Busca.new(parametros: form_params).parametros.should
      eq("titulo:linguagens dinâmicas "\
         "autor:Why "\
         "sub_area:Computação "\
         "area:Exatas "\
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
