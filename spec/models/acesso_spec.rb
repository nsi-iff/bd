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

  #TODO: fix this shit!
  #it 'faz a contagem de acesso diariamente as 23:58' do
  #  Acesso.count.should == 0
  #  Delorean.time_travel_to Date.today.strftime('%Y-%m-22') + ' 11:58 pm'
  #  sleep(1)
  #  Acesso.total_de_acessos.should == 3
  #  Delorean.back_to_the_present
  #end
end
