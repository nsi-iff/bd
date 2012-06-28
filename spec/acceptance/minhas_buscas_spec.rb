# encoding: utf-8

require 'spec_helper'
Dir.glob(Rails.root + '/app/models/*.rb').each { |file| require file }

feature 'Buscas' do
  before(:each) do
    Tire.criar_indices if ENV['INTEGRACAO_TIRE']
    Papel.criar_todos
  end

  context 'busca avançada (busca no acervo)', busca: true do
    scenario 'deve buscar por título' do
      livro = create(:livro)
      livro.submeter! && livro.aprovar!
      Conteudo.tire.index.refresh if ENV['INTEGRACAO_TIRE']

      visit buscas_path
      fill_in 'parametros[titulo]', with: livro.titulo
      click_button 'Buscar'

      page.should have_content livro.titulo
      page.should_not have_content("Não foi encontrado resultado para sua busca.")
    end

    scenario 'busca pelo nome do autor' do
      livro = create(:livro)
      livro.submeter! && livro.aprovar!
      Conteudo.tire.index.refresh if ENV['INTEGRACAO_TIRE']

      visit buscas_path
      fill_in 'parametros[nome]', with: livro.autores.first.nome
      click_button 'Buscar'
      page.should have_content livro.titulo
      page.should_not have_content("Não foi encontrado resultado para sua busca.")
    end

    scenario 'busca por tipo de conteúdo' do
      livro = create(:livro, titulo: "teste livro")
      artigo = create(:artigo_de_periodico, titulo: "teste artigo")
      livro.submeter! && livro.aprovar!
      artigo.submeter! && artigo.aprovar!
      Conteudo.tire.index.refresh if ENV['INTEGRACAO_TIRE']

      visit buscas_path
      fill_in 'parametros[titulo]', with: livro.titulo
      find(:css, "#parametros_tipos_[value='livro']").set(true)
      click_button 'Buscar'
      page.should have_content livro.titulo
      page.should_not have_content("Não foi encontrado resultado para sua busca.")
    end

    scenario 'busca por mais de tipo de conteúdo' do
      livro = create(:livro, titulo: "teste livro")
      artigo = create(:artigo_de_periodico, titulo: "teste artigo")
      livro.submeter! && livro.aprovar!
      artigo.submeter! && artigo.aprovar!
      Conteudo.tire.index.refresh if ENV['INTEGRACAO_TIRE']

      visit buscas_path
      fill_in 'parametros[titulo]', with: livro.titulo
      find(:css, "#parametros_tipos_[value='livro']").set(true)
      find(:css, "#parametros_tipos_[value='artigo_de_periodico']").set(true)
      click_button 'Buscar'
      page.should have_content livro.titulo
      page.should have_content artigo.titulo
      page.should_not have_content("Não foi encontrado resultado para sua busca.")
    end


    scenario 'busca pelo nome da área' do
      livro = create(:livro, titulo: "teste livro")
      livro.submeter! && livro.aprovar!
      Conteudo.tire.index.refresh if ENV['INTEGRACAO_TIRE']

      visit buscas_path
      select livro.area.nome, from: 'parametros[area_nome]'
      click_button 'Buscar'
      page.should have_content livro.titulo
      page.should_not have_content("Não foi encontrado resultado para sua busca.")
    end

    scenario 'busca pelo nome da sub-área' do
      livro = create(:livro, titulo: "teste livro")
      livro.submeter! && livro.aprovar!
      Conteudo.tire.index.refresh if ENV['INTEGRACAO_TIRE']

      visit buscas_path
      select livro.sub_area.nome, from: 'parametros[sub_area_nome]'
      click_button 'Buscar'
      page.should have_content livro.titulo
      page.should_not have_content("Não foi encontrado resultado para sua busca.")
    end

    scenario 'busca pelo nome da instituição' do
      livro = create(:livro, titulo: "teste livro")
      livro.submeter! && livro.aprovar!
      Conteudo.tire.index.refresh if ENV['INTEGRACAO_TIRE']

      visit buscas_path
      select livro.campus.instituicao.nome, from: 'parametros[instituicao_nome]'
      click_button 'Buscar'
      page.should have_content livro.titulo
      page.should_not have_content("Não foi encontrado resultado para sua busca.")
    end

    scenario 'deve buscar por texto-integral' do
      livro = create(:livro, resumo: 'texto integral')
      livro.submeter! && livro.aprovar!
      Conteudo.tire.index.refresh if ENV['INTEGRACAO_TIRE']

      visit buscas_path
      fill_in 'busca', with: livro.resumo
      click_button 'Buscar'

      page.should have_content livro.titulo
      page.should_not have_content("Não foi encontrado resultado para sua busca.")
    end
  end

  scenario 'salvar busca' do
    usuario = autenticar_usuario(Papel.membro)
    livro = create(:livro, titulo: 'My book')
    livro2 = create(:livro, titulo: 'Outro book')
    Conteudo.tire.index.refresh if ENV['INTEGRACAO_TIRE']
    visit root_path
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

    livro = create(:livro, titulo: 'livro')

    visit root_path
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
    visit root_path
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

  # TODO: resolver o problema da intermitência na integração contínua. teste removido até que o problema seja resolvido.
#  scenario 'as 2:00 o servico de mala direta envia emails', busca: true do
#    usuario_1 = create :usuario

#    Delorean.time_travel_to Date.yesterday do
#      artigo = create(:livro, titulo: 'livro')
#      artigo.submeter!
#      artigo.aprovar!
#    end

#    Busca.create(titulo: 'busca artigo',
#                 busca: 'livro',
#                 usuario: usuario_1,
#                 mala_direta: true)

#    artigo = create(:artigo_de_evento, titulo: 'artigo')
#    artigo.submeter!
#    artigo.aprovar!

#    usuario_2 = create :usuario
#    Busca.create(titulo: 'busca artigo',
#                 busca: 'artigo',
#                 usuario: usuario_2,
#                 mala_direta: true)

#    #nenhum email foi enviado

#    amanha_quase_as_duas = Date.tomorrow.strftime('%Y-%m-%d') + ' 1:59:57 am'
#    expect {
#      Delorean.time_travel_to(amanha_quase_as_duas) { sleep(5) } # tempo para esperar enviar e-mail
#    }.to change { ActionMailer::Base.deliveries.size }.by 1
#    email = ActionMailer::Base.deliveries.last
#    email.to.should == [usuario_2.email]
#    email.subject.should == 'Biblioteca Digital: Novos documentos de seu interesse'
#  end

  scenario 'nenhuma busca salva' do
    usuario = autenticar_usuario(Papel.membro)
    visit root_path
    within '#minhas_buscas' do
      page.should have_content 'Não há buscas salvas.'
    end
    visit minhas_buscas_usuario_path(usuario)
    within '.content' do
      page.should have_content 'Não há buscas salvas.'
    end
  end

  scenario 'usuario não autenticado não pode salvar buscas' do
    visit buscas_path
    page.should_not have_content "Salvar Busca"
  end
  scenario "em uma busca vazia não retornar resultados" do
    visit buscas_path
    click_button 'Buscar'
    page.should have_content "Busca não realizada. Favor preencher algum critério de busca"
  end
end
