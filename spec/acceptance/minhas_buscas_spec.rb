# encoding: utf-8

require 'spec_helper'

feature 'Buscas' do
  before(:all) do
    Tire.criar_indices if ENV['INTEGRACAO_TIRE']
  end

  before(:each) do
    Papel.criar_todos
  end

  scenario 'salvar busca' do
    usuario = autenticar_usuario(Papel.membro)
    livro = FactoryGirl.create(:livro, titulo: 'My book')
    livro2 = FactoryGirl.create(:livro, titulo: 'Outro book')
    sleep(3) if ENV['INTEGRACAO_TIRE'] # espera indexar
    visit "/buscas"
    fill_in 'Busca', with: 'book'
    click_button 'Buscar'
    click_link 'Salvar Busca'
    fill_in 'Título', with: 'Buscas book'
    fill_in 'Descriçao', with: 'Primeira busca'
    click_button 'Salvar'

    page.should have_content 'Busca salva com sucesso'
    visit root_path
    page.should have_link 'Buscas book'
  end

  scenario 'ver minhas buscas' do
    usuario = autenticar_usuario(Papel.membro)
    page.should_not have_link 'Gerenciar buscas'

    livro = FactoryGirl.create(:livro, titulo: 'livro')

    visit "/buscas"
    fill_in 'Busca', with: 'livro'
    click_button 'Buscar'
    click_link 'Salvar Busca'
    fill_in 'Título', with: 'Buscar livro'
    click_button 'Salvar'

    page.should have_link 'Buscar livro'
    page.should have_link 'Gerenciar buscas'

    click_link 'Gerenciar buscas'
    page.should have_content 'Minhas Buscas'
    page.should have_link 'Buscar livro'
    page.should have_link 'Editar'
    page.should have_link 'Deletar'

    page.has_selector?('input', :type => 'checkbox')
  end

  scenario 'cadastrar busca salva no servico de mala direta' do
    usuario = autenticar_usuario(Papel.contribuidor)
    submeter_conteudo :artigo_de_evento, titulo: 'artigo', link: 'link', arquivo: ''
    page.should have_content 'com sucesso'
    visit "/buscas"
    fill_in 'Busca', with: 'livro'
    click_button 'Buscar'
    click_link 'Salvar Busca'

    fill_in 'Título', with: 'Buscar livro'
    click_button 'Salvar'

    page.should have_link 'Buscar livro'
    page.should have_link 'Gerenciar buscas'

    Busca.count.should == 1
    click_link 'Gerenciar buscas'

    busca = Busca.first
    busca.mala_direta.should == false

    busca.mala_direta = true
    busca.mala_direta.should == true
  end

  scenario 'as 2:00 o servico de mala direta envia emails' do
    quantidade_inicial = ActionMailer::Base.deliveries.size
    usuario_1 = FactoryGirl.create :usuario

    Delorean.time_travel_to Date.yesterday do
      artigo = FactoryGirl.create(:livro, titulo: 'livro')
      artigo.submeter!
      artigo.aprovar!
    end

    Busca.create(titulo: 'busca artigo',
                 busca: 'livro',
                 usuario: usuario_1,
                 mala_direta: true)

    artigo = FactoryGirl.create(:artigo_de_evento, titulo: 'artigo')
    artigo.submeter!
    artigo.aprovar!

    usuario_2 = FactoryGirl.create :usuario
    Busca.create(titulo: 'busca artigo',
                 busca: 'artigo',
                 usuario: usuario_2,
                 mala_direta: true)

    #nenhum email foi enviado
    #ActionMailer::Base.deliveries.should be_empty

    amanha_quase_as_duas = Date.tomorrow.strftime('%Y-%m-%d') + ' 1:59:58 am'
    Delorean.time_travel_to amanha_quase_as_duas do
      sleep(3) #tempo para esperar enviar e-mail

      ActionMailer::Base.deliveries.size.should == quantidade_inicial + 1

      email = ActionMailer::Base.deliveries.last
      email.to.should == [usuario_2.email]
      email.subject.should == 'Biblioteca Digital: Novos documentos de seu interesse'
    end
  end

  scenario 'nenhuma busca salva' do
    usuario = autenticar_usuario(Papel.membro)
    visit root_path
    within '#minhas_buscas' do
      page.should have_content 'Não há buscas salvas.'
    end
    visit usuario_minhas_buscas_path(usuario)
    within '.content' do
      page.should have_content 'Não há buscas salvas.'
    end
  end

  scenario 'usuario não autenticado não pode salvar buscas' do
    visit buscas_path
    page.should_not have_content "Salvar Busca"
  end
end
