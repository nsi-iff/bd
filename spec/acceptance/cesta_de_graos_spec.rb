# encoding: utf-8

require 'spec_helper'

feature 'cesta de grãos' do
  before :all do
    require File.join(Rails.root, *%w(db criar_indices))

    # monkeypatch temporario para passar no teste sem o Elastic Search
    # TODO: remover depois que funcionarem buscas básicas com o ES fake
    class << Conteudo
      alias old_search search
      def search(param)
        where('upper(titulo) like ?', "%#{param.to_s.upcase}%")
      end
    end
  end

  after :all do
    class << Conteudo
      alias search old_search
    end
  end

  before(:each) do
    @livro = Factory.create(:livro, titulo: 'Quantum Mechanics for Dummies')
    @grao1 = Factory.create(:grao_imagem, key: '12345', conteudo: @livro)
    @grao2 = Factory.create(:grao_arquivo, key: '67890', conteudo: @livro)
    sleep(3) if ENV['INTEGRACAO'] # aguardar a indexacao
  end

  def incluir_grao_na_cesta
    buscar_por 'Mechanics'

    within item_de_busca(resultado: 1, grao: 1) do
      click_link 'Adicionar à cesta'
    end
    within('#cesta') { page.should have_content representacao_grao(@grao1) }

    buscar_por 'for Dummies'

    within item_de_busca(resultado: 1, grao: 2) do
      click_link 'Adicionar à cesta'
    end

    within item_da_cesta(2) do
      page.should have_content representacao_grao(@grao2)
    end
  end

  def excluir_grao_da_cesta
    buscar_por 'Mechanics'

    within item_de_busca(resultado: 1, grao: 1) do
      click_link 'Adicionar à cesta'
    end
    within item_de_busca(resultado: 1, grao: 2) do
      click_link 'Adicionar à cesta'
    end
    sleep(1) # esperar o javascript trabalhar

    visit root_path
    within '#cesta' do
      page.should have_content representacao_grao(@grao1)
      page.should have_content representacao_grao(@grao2)
    end

    within item_da_cesta(1) do
      click_link 'Remover'
    end
    within '#cesta' do
      page.should_not have_content representacao_grao(@grao1)
      page.should have_content representacao_grao(@grao2)
    end

    within '#cesta'  do
      click_link 'Remover'
    end
    within '#cesta' do
      page.should_not have_content representacao_grao(@grao1)
      page.should_not have_content representacao_grao(@grao2)
    end
  end

  context 'usuário anônimo' do
    scenario 'incluir grão na cesta', javascript: true do
      incluir_grao_na_cesta
    end

    scenario 'excluir grão da cesta', javascript: true do
      excluir_grao_da_cesta
    end

    scenario 'cesta é zerada em nova sessão', javascript: true do
      incluir_grao_na_cesta
      page.should have_selector '#cesta #items'
      autenticar_usuario
      deslogar
      page.should_not have_selector '#cesta #items'
    end
  end

  context 'usuário logado' do
    before :each do
      criar_papeis
      @usuario = autenticar_usuario(Papel.membro)
    end

    scenario 'incluir grão na cesta', javascript: true do
      incluir_grao_na_cesta
    end

    scenario 'excluir grão da cesta', javascript: true do
      excluir_grao_da_cesta
    end

    scenario 'cesta sobrevive de uma sessão para outra', javascript: true do
      incluir_grao_na_cesta
      within '#cesta' do
        [@grao1, @grao2].each {|g|
          page.should have_content representacao_grao(g)
        }
      end
      deslogar
      page.should_not have_selector '#cesta #items'
      autenticar(@usuario)
      within '#cesta' do
        [@grao1, @grao2].each {|g|
          page.should have_content representacao_grao(g)
        }
      end
    end
  end
end

def representacao_grao(grao)
  "%s %s" % [grao.key, grao.tipo_humanizado]
end
