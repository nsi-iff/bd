# encoding: utf-8

require 'spec_helper'

describe PagesController do
  include ControllerAuth
  
  describe 'GET adicionar_conteudo' do
    before(:each) { login create(:usuario_contribuidor) }
    
    it 'somente autoriza quem pode criar conteudo' do
      controller.should_receive(:authorize!).with(:create, Conteudo)
      get :adicionar_conteudo
    end
  end
end
