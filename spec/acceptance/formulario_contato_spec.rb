#encoding: utf-8
require 'spec_helper'

feature "Formulário de contato" do
  before(:each) { ActionMailer::Base.deliveries = [] }
  scenario "envia mensagem" do
    visit root_path
    click_link 'Contato'
    fill_in 'Nome', :with => 'John Doe'
    fill_in 'Email', :with => 'john-doe@foobar.com'
    fill_in 'Assunto', :with => 'rails'
    fill_in 'Mensagem', :with => 'rails lek'
    click_button 'Enviar'
    page.body.should have_content('Obrigado por entrar em contato')
    last_email = ultimo_email_enviado
    last_email.to.should include('foo@bar.com')
    last_email.from.should include('john-doe@foobar.com')
  end

  scenario "não envia mensagem com campo faltando" do
    visit root_path
    click_link 'Contato'
    fill_in 'Nome', :with => 'John Doe'
    fill_in 'Assunto', :with => 'rails'
    fill_in 'Mensagem', :with => 'campo faltando lek'
    click_button 'Enviar'
    page.body.should have_content("não pode ficar em branco")
    ultimo_email_enviado.should == nil
  end
end
