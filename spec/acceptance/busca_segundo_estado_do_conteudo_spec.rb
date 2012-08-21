# encoding: utf-8

require 'spec_helper'

feature 'Busca por estado do conteudo', busca: true do
  before(:each) do
    Tire.criar_indices
    Papel.criar_todos
    iff = Instituicao.create(nome: 'IFF')
    @campos_centro = Campus.create nome: 'Campos Centro', instituicao: iff
    @artigo_1 = create(:artigo_de_evento, titulo: 'artigo do iff', campus: @campos_centro)
    @artigo_2 = create(:artigo_de_evento, titulo: 'artigo 2 do iff', campus: @campos_centro)
    @artigo_3 = create(:artigo_de_evento, titulo: 'artigo 3 do iff', campus: @campos_centro)
    @artigo_4 = create(:artigo_de_evento, titulo: 'artigo 4 do iff', campus: @campos_centro)
  end

  scenario 'gestor pode buscar por conteudos pendentes, publicados e recolhidos' do
    usuario = autenticar_usuario(Papel.gestor)
    usuario.campus = @campos_centro
    usuario.save

    visit buscas_path
    page.should have_css "ul#estado_do_conteudo"

    within "ul#estado_do_conteudo" do
      page.should have_content "Pendente"
      page.should have_content "Publicado"
      page.should have_content "Recolhido"
      page.should_not have_content "Editável"
    end

    aprovar(@artigo_1) # artigo 1 aprovado
    @artigo_2.submeter! # artigo 2 pendente
    aprovar(@artigo_3)
    @artigo_3.recolher! #artigo 3 recolhido
    #artigo_4 editavel
    Conteudo.index.refresh

    fill_in 'parametros_titulo', with: 'artigo'
    check 'Pendente'
    check 'Publicado'
    check 'Recolhido'
    click_button 'Buscar'

    page.should have_link 'artigo do iff'
    page.should have_link 'artigo 2 do iff'
    page.should have_link 'artigo 3 do iff'
    page.should_not have_link 'artigo 4 do iff'
  end

  scenario 'administrador pode buscar por conteudos editaveis,
            pendentes, publicados e recolhidos' do
    usuario = autenticar_usuario(Papel.instituicao_admin)
    usuario.campus = @campos_centro
    usuario.save

    visit buscas_path
    page.should have_css "ul#estado_do_conteudo"

    within "ul#estado_do_conteudo" do
      page.should have_content "Pendente"
      page.should have_content "Publicado"
      page.should have_content "Recolhido"
      page.should have_content "Editável"
    end

    @artigo_1.submeter!
    @artigo_1.aprovar! # artigo 1 aprovado
    @artigo_2.submeter! # artigo 2 pendente
    @artigo_3.submeter!
    @artigo_3.aprovar!
    @artigo_3.recolher! #artigo 3 recolhido
    #artigo_4 editavel
    Conteudo.index.refresh

    fill_in 'parametros_titulo', with: 'artigo'
    check 'Pendente'
    check 'Publicado'
    check 'Recolhido'
    check 'Editável'
    click_button 'Buscar'

    page.should have_link 'artigo do iff'
    page.should have_link 'artigo 2 do iff'
    page.should have_link 'artigo 3 do iff'
    page.should have_link 'artigo 4 do iff'

    usuario = autenticar_usuario(Papel.admin)
    usuario.campus = @campos_centro
    usuario.save

    visit buscas_path
    page.should have_css "ul#estado_do_conteudo"

    within "ul#estado_do_conteudo" do
      page.should have_content "Pendente"
      page.should have_content "Publicado"
      page.should have_content "Recolhido"
      page.should have_content "Editável"
    end
  end

  scenario 'usuario comum e contribuidor nao podem ver opcoes de busca por estados' do
    usuario = autenticar_usuario(Papel.membro)
    usuario.campus = @campos_centro
    usuario.save

    visit buscas_path
    page.should_not have_css "ul#estado_do_conteudo"

    usuario = autenticar_usuario(Papel.contribuidor)
    usuario.campus = @campos_centro
    page.should_not have_css "ul#estado_do_conteudo"
  end

  scenario 'usuario não logado nao pode ver opcoes de busca por estados' do
    visit buscas_path
    page.should_not have_css "ul#estado_do_conteudo"
  end
end
