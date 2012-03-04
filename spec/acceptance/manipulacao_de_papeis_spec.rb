# encoding: utf-8

require 'spec_helper'

feature 'mudar papel do usuário' do
  scenario 'usuário não admin, não pode acessar página de manipulação de papéis' do
    criar_papeis
    autenticar_usuario

    visit '/usuarios'

    page.should have_content 'Acesso negado'
  end

  scenario 'admin pode acessar página de manipulação de papéis e alterar papéis de usuários' do
    criar_papeis
    autenticar_usuario Papel.admin

    visit '/usuarios'
    check 'foo@bar.com["membro"]'
    check 'foo@bar.com["gestor"]'
    click_button 'Salvar'

    foobar = Usuario.find_by_nome_completo('Foo Bar')
    foobar.membro?.should == true
    foobar.gestor?.should == true
    page.has_checked_field? 'foo@bar.com["membro"]'
    page.has_checked_field? 'foo@bar.com["gestor"]'
  end
end
