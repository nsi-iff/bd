# encoding: utf-8

require 'spec_helper'

feature 'sessão e registro de usuário' do

  before(:each) do
    Papel.criar_todos
  end

  scenario 'modificar opções de campus ao modificar instituição', :js => true do
    popular_instituicao_campus
    visit root_path
    click_link 'Registrar Usuário'
    select 'Instituto Federal de Educação, Ciência e Tecnologia do Amapá', from: 'select_instituicao'
    select 'Campus Macapá', from: 'Campus'
    select 'Instituto Federal de Educação, Ciência e Tecnologia Fluminense', from: 'select_instituicao'
    select 'Campus Macaé', from: 'Campus'
    select 'Campus Campos Centro', from: 'Campus'
  end

  scenario 'cadastrar usuario' do
    popular_instituicao_campus
    visit root_path
    click_link 'Registrar Usuário'
    fill_in 'Nome Completo', with: 'Foo Bar'
    fill_in 'E-mail', with: 'foo@bar.com'
    fill_in 'Senha', with: 'foobar'
    fill_in 'Confirmação de Senha', with: 'foobar'
    select 'Instituto Federal de Educação, Ciência e Tecnologia Fluminense', from: 'select_instituicao'
    select 'Campus Campos Centro', from: 'Campus'
    click_button 'Registrar'
    page.should have_content 'A sua conta foi criada com sucesso. No entanto, não foi possível fazer login, pois ela não foi confirmada'
  end

  scenario 'acessar sistema' do
    usuario = create :usuario, password: 'foobar', password_confirmation: 'foobar'

    visit root_path
    click_link 'Acessar'
    fill_in 'E-mail', with: usuario.email
    fill_in 'Senha', with: 'foobar'
    click_button 'Entrar'

    page.should have_content 'Login efetuado com sucesso'
  end

  scenario 'sair do sistema' do
    autenticar_usuario

    click_link 'Sair'

    page.should have_content 'Logout efetuado com sucesso'
  end

  scenario 'solicitar alteração e senha' do
    usuario = create :usuario
    visit root_path
    click_link 'Acessar'
    click_link 'Esqueceu a senha?'
    fill_in 'Email', with: usuario.email
    click_button 'Envie as instruções de mudança de senha'
    sleep(3) #tempo para esperar enviar e-mail
    page.should have_content("Dentro de minutos, você receberá um email com as instruções de reinicialização da sua senha.")
    last_email = ActionMailer::Base.deliveries.last
    last_email.to.should include(usuario.email)
  end

  scenario 'modificar instituição de origem' do
    popular_instituicao_campus
    usuario = create(:usuario, campus: Campus.find_by_nome('Campus Campos Centro'))
    usuario.confirm!
    autenticar(usuario)

    visit edit_usuario_registration_path

    select 'Instituto Federal de Educação, Ciência e Tecnologia Fluminense', from: 'select_instituicao'
    select 'Campus Macaé', from: 'select_campus'
    click_button 'Atualizar'
    page.should have_content 'Suas alterações foram salvas com sucesso'

    usuario.reload.campus.nome.should == "Campus Macaé"
  end

  scenario 'administrador de instituição não pode atribuir papel de administrador geral' do
    Papel.criar_todos
    usuario = create(:usuario, papeis: [Papel.instituicao_admin])
    autenticar(usuario)
    visit papeis_usuarios_path
    within '#papeis-usuarios' do
      page.should have_content usuario.nome_completo
      page.should_not have_selector :css, '.admin'
    end

    admin = create(:usuario, papeis: [Papel.admin], campus: usuario.campus)
    autenticar(admin)
    visit papeis_usuarios_path
    within '#papeis-usuarios' do
      page.should have_selector :css, '.admin'
    end
  end
end

