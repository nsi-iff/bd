# encoding: UTF-8

require 'spec_helper'
require './spec/support/cesta.rb'
require './spec/support/papel.rb'

feature "editor online" do
  scenario "fazer download do conteúdo do editor" do
    visit "/editor"
    fill_in "documento", with: "teste"
    click_button "Download"
    headers['Content-Transfer-Encoding'].should == 'binary'
    headers['Content-Type'].should == 'text/html'
    page.body.should match("teste")
  end

  scenario "inserir referências dos grãos baixados do editor" do
    Papel.criar_todos
    @usuario = autenticar_usuario(Papel.membro)
    @livro = create(:livro, titulo: 'Biblioteca Digital da RENAPI')
    Livro.any_instance.stub(:referencia_abnt).and_return("Referência ABNT")
    criar_cesta(@usuario, @livro, *%w(./spec/resources/biblioteca_digital.png))
    visit "/editor?graos=true"
    click_button "Download"
    page.body.should match("Refer&ecirc;ncia ABNT") # entidade para 'ê': &ecirc;
  end

  def headers
    page.response_headers
  end
end

