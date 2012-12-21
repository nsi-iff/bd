# encoding: utf-8

#require 'spec_helper'

#feature 'extrair automaticamente os metadados do arquivo do conteudo' do
#  before(:each) do
#    popular_area_sub_area if Area.count == 0
#    Papel.criar_todos if Papel.count == 0
#    autenticar_usuario(Papel.contribuidor)
#  end

#  scenario 'tipo de conteúdo Artigo de Evento' do
#    visit new_conteudo_path(tipo: :artigo_de_evento)
#    attach_file('Arquivo', File.join(Rails.root, *%w(spec resources artigo_de_evento.pdf)))

#    click_button 'Salvar'

#    artigo_de_evento = ArtigoDeEvento.last
#    artigo_de_evento.resumo.should_not be_nil
#    artigo_de_evento.titulo.should_not be_nil
#    artigo_de_evento.autores.should_not be_nil
#    artigo_de_evento.numero_paginas.should_not be_nil
#  end

  #TODO Verificar ser nsi.metadataextractor já realiza a extração em Artigo de Periódico
#  scenario 'tipo de conteúdo Artigo de Periódico' do
#    visit new_conteudo_path(tipo: :artigo_de_periodico)
#    attach_file('Arquivo', File.join(Rails.root, *%w(spec resources tcc.pdf)))

#    click_button 'Salvar'

#    artigo_de_periodico = ArtigoDePeriodico.last
#    artigo_de_periodico.resumo == ""
#    artigo_de_periodico.titulo.should == ""
#    artigo_de_periodico.autores == ""
#    artigo_de_periodico.numero_paginas == ""
#  end

#  scenario 'tipo de conteúdo Trabalho de Obtenção de Grau' do
#    popular_graus
#    visit new_conteudo_path(tipo: :trabalho_de_obtencao_de_grau)
#    attach_file('Arquivo', File.join(Rails.root, *%w(spec resources tcc.pdf)))
#    select 'Graduação', from: 'Grau'

#    click_button 'Salvar'

#    tcc = TrabalhoDeObtencaoDeGrau.last
#    tcc.resumo.should_not be_nil
#    tcc.titulo.should_not be_nil
#    tcc.autores.should_not be_nil
#    tcc.numero_paginas.should_not be_nil
#  end

#  scenario 'insucesso na extração de metadados não pode impedir envio do conteúdo' do
#    popular_graus
#    visit new_conteudo_path(tipo: :artigo_de_evento)
#    attach_file('Arquivo', File.join(Rails.root, *%w(spec resources tcc.pdf)))

#    click_button 'Salvar'

#    artigo_de_evento = ArtigoDeEvento.last
#    artigo_de_evento.resumo.should be_blank
#    artigo_de_evento.titulo.should be_blank
#    artigo_de_evento.autores.should be_blank
#    artigo_de_evento.numero_paginas.should be_blank

#    page.should have_content "sucesso"
#  end
#end
