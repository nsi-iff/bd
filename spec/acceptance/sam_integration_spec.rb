#encoding: utf-8

require 'spec_helper'
require 'nsisam'
require 'base64'

feature 'Integração com o SAM', :if => ENV['INTEGRACAO_SAM'] do
  before(:all) do
    config = Rails.application.config
    @sam = NSISam::Client.new "http://#{config.sam_user}:#{config.sam_password}@#{config.sam_host}:#{config.sam_port}"
  end

  scenario 'padrão' do
    submeter_conteudo :artigo_de_evento, titulo: 'integracao sam', link: '', arquivo: Rails.root + 'spec/resources/arquivo.pdf'
    page.should have_content 'com sucesso'

    @artigo = ArtigoDeEvento.find_by_titulo('integracao sam')

    response = @sam.get(@artigo.arquivo.key)
    response.should have(3).keys

    response.should have_key("from_user")
    response["from_user"].should == Rails.application.config.sam_user

    response.should have_key("date")

    arquivo_64 = Base64.encode64(File.open('spec/resources/arquivo.nsi').read)
    response.should have_key("data")
    response["data"].should == arquivo_64
  end
end
