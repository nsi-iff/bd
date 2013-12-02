# encoding: UTF-8
require "spec_helper"

describe BuscasController do
  context "post 'busca_avancada'" do
    it "deve apenas instanciar uma busca" do
      post :busca_avancada, parametros: {titulo: "linguagens dinâmicas"}
      assigns[:busca].should be_new_record
    end

    it "deve passar os parametros do form para a busca" do
      Busca.should_receive(:new).with(
        busca: nil,
        parametros: {"titulo" => "linguagens dinâmicas"}).
        and_return(double(:busca).as_null_object)
      post :busca_avancada, parametros: {titulo: "linguagens dinâmicas"}
    end

    it "deve instanciar a lista com os resultados" do
      Busca.any_instance.should_receive(:resultados).and_return(['conteudo'])
      post :busca_avancada, parametros: {titulo: "linguagens dinâmicas"}
      assigns[:resultados].should eq(['conteudo'])
    end
  end
end
