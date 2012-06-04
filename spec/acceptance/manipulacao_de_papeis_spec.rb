# encoding: utf-8

require 'spec_helper'

feature 'mudar papel do usuário' do
  scenario 'usuário não admin, não pode acessar página de manipulação de papéis' do
    Papel.criar_todos
    autenticar_usuario

    visit usuarios_papeis_path

    page.should have_content 'Acesso negado'
  end

  scenario 'administrador de instituição pode gerenciar apenas usuários de sua instituição' do
    Papel.criar_todos
    ins1 = Instituicao.create(nome: 'instituicao1')
    camp1 = ins1.campus.create(nome: 'campus1')
    ins2 = Instituicao.create(nome: 'instituicao2')
    camp2 = ins2.campus.create(nome: 'campus2')
    usuario = create(:usuario, campus: camp1)
    usuario.papeis << Papel.instituicao_admin
    create(:usuario, nome_completo: 'Rodrigo', campus: camp1)
    create(:usuario, nome_completo: 'Priscila', campus: camp2)
    autenticar(usuario)

    visit usuarios_papeis_path
    page.should have_content 'Rodrigo'
    page.should_not have_content 'Priscila'

  end

  scenario 'admin pode acessar página de manipulação de papéis e alterar papéis de usuários' do
    Papel.criar_todos
    usuario = autenticar_usuario(Papel.admin)

    visit usuarios_papeis_path
    check "#{usuario.email}[\"membro\"]"
    check "#{usuario.email}[\"gestor\"]"
    click_button 'Salvar'

    foobar = usuario.reload
    foobar.membro?.should == true
    foobar.gestor?.should == true
    visit usuarios_papeis_path
    page.should have_checked_field "#{usuario.email}[\"membro\"]"
    page.should have_checked_field "#{usuario.email}[\"gestor\"]"
  end

  scenario 'listar usuários por instituição' do
    Papel.criar_todos
    autenticar_usuario Papel.admin
    ins1 = Instituicao.create(nome: 'instituicao1')
    camp1 = ins1.campus.create(nome: 'campus1')
    ins2 = Instituicao.create(nome: 'instituicao2')
    camp2 = ins2.campus.create(nome: 'campus2')

    create(:usuario_gestor, nome_completo: 'Rodrigo', campus: camp1)
    create(:usuario_contribuidor, nome_completo: 'Priscila', campus: camp2)

    visit usuarios_papeis_path
    page.should have_content 'Rodrigo'
    page.should have_content 'Priscila'

    select ins1.nome, from: 'Listar usuários do Instituicao'
    click_button 'Listar'

    page.should have_content 'Rodrigo'
    page.should_not have_content 'Priscila'

    select ins2.nome, from: 'Listar usuários do Instituicao'
    click_button 'Listar'

    page.should_not have_content 'Rodrigo'
    page.should have_content 'Priscila'
  end

  scenario 'buscar usuário' do
    Papel.criar_todos
    autenticar_usuario Papel.admin
    create(:usuario_gestor, nome_completo: 'Rodrigo Manhães', email: 'rodrigo@manhaes.com')
    create(:usuario_contribuidor, nome_completo: 'Priscila Manhães', email: 'priscila@manhaes.com')
    create(:usuario_gestor, nome_completo: 'Larva Fire')

    visit usuarios_papeis_path
    fill_in 'Buscar por nome', with: 'Manhães'
    click_button 'Buscar'

    page.should have_content 'Rodrigo Manhães'
    page.should have_checked_field 'rodrigo@manhaes.com["gestor"]'
    page.should have_content 'Priscila Manhães'
    page.should have_checked_field 'priscila@manhaes.com["contribuidor"]'
    page.should_not have_content 'Larva Fire'
  end
end
