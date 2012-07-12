require 'spec_helper'

describe ArtigoDePeriodico do
  it { should have_valid(:volume_publicacao).when 1, 20, '', nil   }
  it { should_not have_valid(:volume_publicacao).when 0, -5 }

  it { should have_valid(:data_publicacao_br).when '', '01/06/1994', '03/10/1996' }
  it { should_not have_valid(:data_publicacao_br).when '0', '2011/04/04', '03/2011/04' }

  it "pagina final tem que ser maior que pagina final" do
    artigo_1 = ArtigoDeEvento.new pagina_inicial: 10
    artigo_1.should have_valid(:pagina_final).when 20

    artigo_2 = ArtigoDeEvento.new pagina_inicial: 30
    artigo_2.should_not have_valid(:pagina_final).when 20
  end
end
