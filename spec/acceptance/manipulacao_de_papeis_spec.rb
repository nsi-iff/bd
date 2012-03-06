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
    usuario = autenticar_usuario(Papel.admin)

    visit '/usuarios'
    check "#{usuario.email}[\"membro\"]"
    check "#{usuario.email}[\"gestor\"]"
    click_button 'Salvar'

    foobar = usuario.reload
    foobar.membro?.should == true
    foobar.gestor?.should == true
    page.should have_checked_field "#{usuario.email}[\"membro\"]"
    page.should have_checked_field "#{usuario.email}[\"gestor\"]"
  end

  scenario 'buscar usuário' do
    criar_papeis
    autenticar_usuario Papel.admin
    Factory.create(:usuario_gestor, nome_completo: 'Rodrigo Manhães', email: 'rodrigo@manhaes.com')
    Factory.create(:usuario_contribuidor, nome_completo: 'Priscila Manhães', email: 'priscila@manhaes.com')
    Factory.create(:usuario_gestor, nome_completo: 'Larva Fire')

    visit '/usuarios'
    save_and_open_page
    fill_in 'Buscar por nome', with: 'Manhães'
    click_button 'Buscar'

    page.should have_content 'Rodrigo Manhães'
    page.should have_checked_field 'rodrigo@manhaes.com["gestor"]'
    page.should have_content 'Priscila Manhães'
    page.should have_checked_field 'priscila@manhaes.com["contribuidor"]'
    page.should_not have_content 'Larva Fire'
  end
end
