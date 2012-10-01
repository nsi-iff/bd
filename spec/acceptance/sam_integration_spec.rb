require 'spec_helper'
require 'nsisam'
require 'base64'

feature 'Integracao com o SAM', sam: true do
  let(:sam) { ServiceRegistry.sam }

  scenario 'padrao' do
    submeter_conteudo :artigo_de_evento, titulo: 'integracao sam', link: '', arquivo: Rails.root + 'spec/resources/manual.odt'
    page.should have_content 'com sucesso'

    @artigo = ArtigoDeEvento.find_by_titulo('integracao sam')

    response = sam.get_file(@artigo.arquivo.key)
    response.should_not be_nil

    arquivo = File.open('spec/resources/manual.odt', 'rb').read
    response.file.should_not be_nil

    arquivo.should == response.file
  end
end
