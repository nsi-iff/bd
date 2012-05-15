# encoding: utf-8

require 'spec_helper'

describe TutoriaisHelper do
  include Capybara::DSL

  it 'retorna caminho do item especificado' do
    page.visit "/ajuda/tutoriais" do
      helper.url_para("usando_o_plone").should == '/ajuda/tutoriais/usando_o_plone'
    end
  end
end
