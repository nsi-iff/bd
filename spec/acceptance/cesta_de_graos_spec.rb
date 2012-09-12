# encoding: utf-8

require 'spec_helper'

feature 'cesta de grãos' do

  before(:each) do
    Tire.criar_indices
    @livro = create(:livro_publicado, titulo: 'Quantum Mechanics for Dummies')

    conteudo_imagem = Base64.encode64(File.open('spec/resources/tela.png').read)
    conteudo_odt = Base64.encode64(File.open('spec/resources/grao_tabela.odt').read)

    result = ServiceRegistry.sam.store file: conteudo_imagem, filename: 'tela.png'
    @grao1 = create(:grao_imagem, conteudo: @livro, key: result.key)

    result = ServiceRegistry.sam.store(file: conteudo_odt, filename: 'grao.odt')
    @grao2 = create(:grao_arquivo, conteudo: @livro, key: result.key)
    Conteudo.tire.index.refresh
  end

  def incluir_grao_na_cesta_pelo_form
    visit grao_path(@grao1)
    click_button 'Adicionar à Cesta de Grãos'

    within('#cesta') { page.should have_content representacao_grao(@grao1) }

    visit grao_path(@grao2)
    click_button 'Adicionar à Cesta de Grãos'

    within item_da_cesta(2) do
      page.should have_content representacao_grao(@grao2)
    end
  end

  def incluir_graos_na_cesta
    @usuario.cesta << @grao1.referencia
    @usuario.cesta << @grao2.referencia
  end
     
  def excluir_grao_da_cesta(options = {})
    visit grao_path(@grao1)
    click_button 'Adicionar à Cesta de Grãos'

    within('#cesta') { page.should have_content representacao_grao(@grao1) }

    visit grao_path(@grao2)
    click_button 'Adicionar à Cesta de Grãos'

    within item_da_cesta(2) do
      page.should have_content representacao_grao(@grao2)
      click_link 'Remover'
    end
    within '#cesta' do
      page.should have_content representacao_grao(@grao1)
      page.should_not have_content representacao_grao(@grao2)
      click_link 'Remover'
      page.should_not have_content representacao_grao(@grao1)
      page.should_not have_content representacao_grao(@grao2)
    end
     
  end
     
  def comparar_odt(tag, novo, grao)
    test = open_xml(grao).xpath(tag)
    tmp =  open_xml(novo).xpath(tag)
    test.children.count.should == tmp.children.count
  end

  def open_xml(file)
    doc = ZipFile.open(file)
    Nokogiri::XML(doc.read("content.xml"))
  end

  context 'usuário anônimo' do
    scenario 'incluir grão na cesta', js: true do
      incluir_grao_na_cesta_pelo_form
    end

    scenario 'excluir grão da cesta', js: true do
      excluir_grao_da_cesta
    end

    scenario 'cesta é zerada em nova sessão', js: true do
      incluir_grao_na_cesta_pelo_form
      page.should have_selector '#cesta #items'
      autenticar_usuario
      deslogar
      page.should_not have_selector '#cesta #items'
    end
  end

  context 'usuário logado' do
    before :each do
      Papel.criar_todos
      @usuario = autenticar_usuario(Papel.membro)
    end

    scenario 'incluir grão na cesta', js: true do
      incluir_grao_na_cesta_pelo_form
    end

    scenario 'excluir grão da cesta', js: true do
      excluir_grao_da_cesta
    end

    scenario 'editar grão da cesta' do
      criar_cesta @usuario, create(:livro),
                            recurso('grao_teste_0.jpg'),
                            recurso('grao_teste_1.jpg'),
                            recurso('grao_tabela.odt')
      visit root_path
      within('#cesta') { click_link 'Editar' }
      within '#documento' do
        page.should have_selector "img[src^='data:image/xyz;base64']"
        ensure_table 'table',
          [%w(1 2 3),
           %w(4 5 6),
           %w(7 8 9)]
      end
    end

    scenario 'baixar conteudo da cesta' do
      criar_cesta(@usuario, @livro, *%w(./spec/resources/tabela.odt))
      visit root_path
      find('#baixar_conteudo_cesta').click

      FileUtils.rm_rf "#{Rails.root}/spec/resources/downloads/"
      FileUtils.mkdir_p "#{Rails.root}/spec/resources/downloads/"

      Zip::ZipFile.open(Dir["#{Rails.root}/tmp/cesta_temporaria*"].last) do |zip_file|
        zip_file.each do |grao|
          grao_path = File.join("#{Rails.root}/spec/resources/downloads/", grao.name)
          zip_file.extract(grao, grao_path)
        end
      end

      grao_armazenado = Digest::MD5.hexdigest(File.read('./spec/resources/tabela.odt'))
      grao_extraido = Digest::MD5.hexdigest(File.read("#{Rails.root}/spec/resources/downloads/grao_quantum_mechanics_for_dummies_0.odt"))
      grao_armazenado.should == grao_extraido
      referencia_abnt = File.read("#{Rails.root}/spec/resources/downloads/referencias_ABNT.txt")
      referencia_abnt.should match "grao_quantum_mechanics_for_dummies_0.odt: #{@livro.referencia_abnt}"
      FileUtils.rm_rf("#{Rails.root}/spec/resources/downloads")
    end

    scenario 'baixar conteudo da cesta em odt' do
      criar_cesta(@usuario, @livro, *%w(./spec/resources/tabela.odt
                                        ./spec/resources/biblioteca_digital.png
                                        ./spec/resources/grao_teste_0.jpg))
      visit root_path
      find('#baixar_conteudo_cesta_odt').click
      grao_armazenado = "./spec/resources/Linus Torvalds.odt"
      grao_baixado = "#{Rails.root}/tmp/Linus Torvalds.odt"
      comparar_odt('//office:text', grao_baixado, grao_armazenado)

      odt = Zip::ZipFile.open(grao_baixado)
      doc = Document.new(odt.read("content.xml"))
      arquivo_odt = doc.to_s
      arquivo_odt.should match @livro.referencia_abnt
      File.delete(grao_baixado)
    end
  end
end
