#encoding: utf-8

require 'spec_helper'

describe "portlets/_escrivaninha.html.haml" do
  it_behaves_like 'a portlet' do
    let(:options) do
      { 
        usuario: stub_model(Usuario, escrivaninha: 
          (1..8).map {|n| 
            build(:conteudo, id: n, titulo: "Conteudo #{n}", created_at: Time.now)
          }),
        reverse: true
      }
    end
  end
end
