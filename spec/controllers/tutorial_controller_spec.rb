# encoding: utf-8

require 'spec_helper'

describe TutoriaisController do
  describe 'pagina 404 quando caminho nao existe' do
    before do
      get :show, :tutorial => "nao existo"
    end

    it { response.code.should == '404' }
  end

  describe 'retorna pagina requisitada quando caminho é valido' do
     before do
      get :show, :tutorial => "usando_o_portal"
    end

    it { response.should be_success }
  end
end