# encoding: utf-8

require 'spec_helper'

feature 'visualizar estatisticas' do
  scenario 'usuarios cadastrados por ano', javascript: true do
    ano = Date.today.year
    Timecop.travel(2.years.ago) do
      3.times { Factory.create(:usuario) }
    end
    Timecop.travel(1.year.ago) do
      4.times { Factory.create(:usuario) }
    end
    2.times { Factory.create(:usuario) }

    visit estatisticas_path
    choose 'Ano'
    select ano.to_s, from: 'select_ano'
    click_button 'search'
    page.should have_content 'Número de usuários cadastrados: 2'

    visit estatisticas_path
    choose 'Ano'
    select (ano - 1).to_s, from: 'select_ano'
    click_button 'search'
    page.should have_content 'Número de usuários cadastrados: 4'

    visit estatisticas_path
    choose 'Ano'
    select (ano - 2).to_s, from: 'select_ano'
    click_button 'search'
    page.should have_content 'Número de usuários cadastrados: 3'
  end
end
