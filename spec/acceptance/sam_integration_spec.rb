#encoding: utf-8

require 'spec_helper'
require 'nsisam'
require 'base64'

feature 'Integração com o SAM', sam: true do
  let(:sam) { ServiceRegistry.sam }

  scenario 'padrão' do
    submeter_conteudo :artigo_de_evento, titulo: 'integracao sam', link: '', arquivo: Rails.root + 'spec/resources/manual.odt'
    page.should have_content 'com sucesso'

    @artigo = ArtigoDeEvento.find_by_titulo('integracao sam')

    response = sam.get(@artigo.arquivo.key)
    response.should_not be_nil

    arquivo_64 = Base64.encode64(File.open('spec/resources/manual.odt').read)
    response.data.should_not be_nil
    response.data.should have_key("file")
    response.data["file"].should == arquivo_64
  end
end
