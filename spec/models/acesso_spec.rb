require 'spec_helper'

describe Acesso do
  it 'obtem a quantidade de acessos do dia' do
    Time.stub_chain(:new, :day => 26)
    acesso = Acesso.new
    acesso.log_file = "#{Rails.root}/spec/resources/access.log"
    acesso.save
    acesso.quantidade.should == 5
    acesso.data.day.should == Time.now.day
  end

  it 'contabiliza o total de acessos' do
    Time.stub_chain(:new, :day => 26)
    acesso = Acesso.new
    acesso.log_file = "#{Rails.root}/spec/resources/access.log"
    acesso.save
    Time.stub_chain(:new, :day => 22)
    acesso = Acesso.new
    acesso.log_file = "#{Rails.root}/spec/resources/access.log"
    acesso.save
    Acesso.total_de_acessos.should == 8
  end
end
