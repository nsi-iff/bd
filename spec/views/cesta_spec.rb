#encoding: utf-8
require 'spec_helper'

describe "graos/cesta.html.haml" do
  before do
    @usuario = create(:usuario_contribuidor)
    @livro = create(:livro_publicado)
    @cesta = criar_cesta(@usuario, @livro, "#{Rails.root}/spec/resources/imagem_em_tabela.odt")
    assign(:cesta, @cesta)
  end

  it "contém o link para a view do grão" do
    render
    #TODO verificar o caminho do link
    rendered.should have_link(Grao.first.titulo)
  end
end
