# encoding: utf-8

require 'spec_helper'

feature 'Busca por imagem' do

	scenario 'pagina pode ser caregada por usuario anonimo' do
		visit root_path
		click_link 'Busca por Imagem'
		page.should have_css "div.busca_por_imagem_form"
	end
end
