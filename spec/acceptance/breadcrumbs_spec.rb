# encoding: utf-8

require 'spec_helper'

feature 'apresentar breadcrumbs para' do
  scenario 'home' do
    visit root_path
    pagina_deve_ter_breadcrumbs 'Página inicial'
  end
end
