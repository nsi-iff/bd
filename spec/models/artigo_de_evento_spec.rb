require 'spec_helper'

describe ArtigoDeEvento do
  it { should have_valid(:ano_publicacao).when 1990, 2000 }
  it { should_not have_valid(:ano_publicacao).when 1989, 1900 }

  it "pagina final tem que ser maior que pagina final" do
    artigo_1 = ArtigoDeEvento.new pagina_inicial: 10
    artigo_1.should have_valid(:pagina_final).when 20

    artigo_2 = ArtigoDeEvento.new pagina_inicial: 30
    artigo_2.should_not have_valid(:pagina_final).when 20
  end
end
