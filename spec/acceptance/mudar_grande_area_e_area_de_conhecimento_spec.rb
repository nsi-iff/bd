# encoding: utf-8

require 'spec_helper'

feature "Área de Conhecimento" do
	scenario "devem mudar quando outra grande área for selecionada", :javascript => true do
		popular_area_sub_area
		visit new_artigo_de_evento_path
		select('Ciências Exatas e da Terra', :from => 'Grande Área de Conhecimento')
		select('Ciência da Computação', :from => 'Área de Conhecimento*')

		select('Engenharias', :from => 'Grande Área de Conhecimento')
		select('Engenharia de Produção', :from => 'Área de Conhecimento*')		
	end
end