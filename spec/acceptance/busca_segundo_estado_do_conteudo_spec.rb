# encoding: utf-8

require 'spec_helper'

feature 'Busca por estado do conteudo', busca: true do
  before(:each) do
    Tire.criar_indices
    Papel.criar_todos
    iff = Instituicao.create(nome: 'IFF')
    @campos_centro = Campus.create nome: 'Campos Centro', instituicao: iff
    @artigo1 = create(:artigo_de_evento_publicado, titulo: 'artigo do iff', campus: @campos_centro)
    @artigo2 = create(:artigo_de_evento_pendente, titulo: 'artigo 2 do iff', campus: @campos_centro)
    @artigo3 = create(:artigo_de_evento_publicado, titulo: 'artigo 3 do iff', campus: @campos_centro)
    @artigo4 = create(:artigo_de_evento_editavel, titulo: 'artigo 4 do iff', campus: @campos_centro)
  end

  scenario 'gestor pode buscar por conteudos pendentes, publicados e recolhidos' do
    usuario = autenticar_usuario(Papel.gestor)
    usuario.campus = @campos_centro
    usuario.save!

    visit buscas_path

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
    usuario.save!

    visit buscas_path

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
  end
end
