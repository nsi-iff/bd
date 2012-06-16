# encoding: utf-8

require 'spec_helper'

feature 'Estante' do
  before(:each) do
    Papel.criar_todos
    @usuario = autenticar_usuario(Papel.contribuidor)
    @outro_usuario = create(:usuario)
  end

  scenario 'mostra os conteúdos aprovados do usuário' do
    artigo = create(:artigo_de_evento, titulo: 'Ruby is cool!', contribuidor: @usuario)
    relatorio = create(:relatorio, titulo: 'We love Ruby and Agile!', contribuidor: @outro_usuario)

    artigo.submeter!
    visit root_path
    within '#estante' do
      page.should_not have_content 'Ruby is cool!'
      page.should_not have_content 'We love Ruby and Agile!'
    end

    visit estante_usuario_path(@usuario)
    within '.content' do
      page.should_not have_content 'Ruby is cool!'
      page.should_not have_content 'We love Ruby and Agile!'
    end

    artigo.aprovar!
    visit root_path
    within '#estante' do
      page.should have_content 'Ruby is cool!'
      page.should_not have_content 'We love Ruby and Agile!'
    end

    visit estante_usuario_path(@usuario)
    within '.content' do
      page.should have_content 'Ruby is cool!'
      page.should_not have_content 'We love Ruby and Agile!'
    end
  end

  scenario 'mostra conteudos favoritos do usuário' do
    relatorio = create(:relatorio, titulo: 'We love Ruby and Agile!', contribuidor: @outro_usuario)
    relatorio.submeter!
    relatorio.aprovar!

    visit conteudo_path(relatorio)
    click_link 'Favoritar'

    visit root_path
    within '#estante' do
      page.should have_content 'We love Ruby and Agile!'
    end

    visit estante_usuario_path(@usuario)
    within '.content' do
      page.should have_content 'We love Ruby and Agile!'
    end

    visit conteudo_path(relatorio)
    click_link 'Remover favorito'

    visit root_path
    within '#estante' do
      page.should_not have_content 'We love Ruby and Agile!'
    end

    visit estante_usuario_path(@usuario)
    within '.content' do
      page.should_not have_content 'We love Ruby and Agile!'
    end

    visit conteudo_path(relatorio)
    click_link 'Favoritar'

    visit estante_usuario_path(@usuario)
    within '.content' do
      page.should have_content 'We love Ruby and Agile!'
      click_link 'Remover favorito'
    end

    within '#estante' do
      page.should_not have_content 'We love Ruby and Agile!'
    end
  end

  scenario 'mostrar graos favoritos do usuário' do
    # TODO: teste seguinte é de aceitação ou de model ?
    conteudo = create(:livro)
    @usuario.favoritar create(:grao, conteudo: conteudo)
    visit root_path
    within '#estante' do
      page.should have_content 'key imagem'
    end
  end

  scenario 'move graos da cesta para estante (como graos favoritos)' do
    conteudo = create(:livro)
    @usuario.cesta << create(:grao, conteudo: conteudo)

    visit estante_usuario_path(@usuario)

    within '#estante' do
      page.should_not have_content 'key imagem'
    end
    within '.content' do
      page.should_not have_content 'key imagem'
    end

    within '#cesta' do
      page.should have_content 'key imagem'
      click_link 'Mover para estante'
    end

    within '#estante' do
      page.should have_content 'key imagem'
    end
    within '.content' do
      page.should have_content 'key imagem'
    end

    within '#cesta' do
      page.should_not have_content 'key imagem'
    end
  end

  it 'quando referenciavel eh removido, a referencia abnt deve ser mostrada' do
    conteudo = create(:livro)
    conteudo_2 = create(:artigo_de_evento)
    grao = create(:grao, conteudo: conteudo_2)

    @usuario.favoritar conteudo
    @usuario.favoritar grao

    conteudo.destroy
    grao.destroy

    visit estante_usuario_path(@usuario)
    within '#estante' do
      page.should have_content conteudo.referencia_abnt
      page.should have_content conteudo_2.referencia_abnt
    end
  end
end
