# encoding: utf-8

require 'spec_helper'

feature 'adicionar objeto de aprendizagem' do
  before(:each) do
    Idioma.create! descricao: 'Português (Brasil)'
    popular_eixos_tematicos_cursos
    Papel.criar_todos
    Capybara.configure {|c| c.match = :prefer_exact }
  end

  after(:each) do
    Capybara.configure {|c| c.match = :smart }
  end
end
