#encoding: utf-8

require 'spec_helper'

feature 'Integração com o SAM' do
  before(:all) do
    config = Rails.application.config
    @sam = NSISam::Client.new "http://#{config.sam_user}:#{config.sam_password}@#{config.sam_host}:#{config.sam_port}"
  end

  scenario 'padrão' do
    submeter_conteudo :artigo_de_evento, titulo: 'integracao sam', link: '', arquivo: Rails.root + 'spec/resources/arquivo.nsi'
    page.should have_content 'com sucesso'

    @artigo = ArtigoDeEvento.find_by_titulo('integracao sam')

    response = @sam.get(@artigo.arquivo.key)
    response.should have_key("data")
  end
end
