# encoding: utf-8

require 'spec_helper'

describe TutoriaisController do
  describe 'retorna pagina requisitada quando caminho é valido' do
     before do
      get :show, :tutorial => "usando-o-portal"
    end

    it { response.should be_success }
  end
end
