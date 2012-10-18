#encoding: utf-8

require 'spec_helper'

describe "portlets/_cesta_de_graos.html.haml" do
  it_behaves_like 'a portlet' do
    let(:options) do
      (1..8).each do |n|
        Referencia.stub(:referenciavel_por_id_referencia).with(n).and_return(
          stub_model(Grao, imagem?: true, titulo: "Conteudo #{n}"))
      end
      
      {
        assigns: {
          cesta: (1..8).to_a
        }
      }
    end
  end
end
