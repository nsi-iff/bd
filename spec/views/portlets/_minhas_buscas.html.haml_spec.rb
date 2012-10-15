#encoding: utf-8

require 'spec_helper'

describe "portlets/_minhas_buscas.html.haml" do
  it_behaves_like 'a portlet' do
    let(:options) do
      { 
        usuario: stub_model(Usuario, buscas: 
          (1..8).map {|n| 
            build(:busca, id: n, titulo: "Conteudo #{n}", created_at: Time.now)
          }),
        reverse: true
      }
    end
  end
end
