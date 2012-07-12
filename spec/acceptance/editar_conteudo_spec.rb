# encoding: utf-8

require 'spec_helper'

feature 'Editar Conteúdo' do
  context 'conteúdo em estado pendente ou recolhido' do
    scenario 'editar conteúdo' do
      Papel.criar_todos
      autenticar_usuario(Papel.contribuidor)

      tipos_de_conteudo.each do |tipo|
        conteudo = create tipo
        conteudo.submeter
        visit edit_conteudo_path(conteudo)
        page.should have_content 'Conteúdo não pode ser editado'
        current_path.should == conteudo_path(conteudo)
      end
    end
  end

  context 'ações relacionadas ao arquivo do conteudo' do
    scenario 'link para download com o nome do arquivo' do
      Papel.criar_todos
      submeter_conteudo :artigo_de_evento, link: '',
                        arquivo: File.join(Rails.root, *%w(spec resources arquivo.odt))
      artigo = ArtigoDeEvento.last
      visit edit_conteudo_path(artigo)
      click_link "Download: #{artigo.arquivo.nome}"
      baixado = "#{Rails.root}/tmp/#{artigo.titulo}.odt"
      postado = "#{Rails.root}/spec/resources/arquivo.odt"
      FileUtils.compare_file(baixado, postado).should == true
    end

    scenario 'remover arquivo atual' do
      submeter_conteudo :artigo_de_evento, link: '',
                        arquivo: File.join(Rails.root, *%w(spec resources arquivo.odt))
      artigo = ArtigoDeEvento.last
      visit edit_conteudo_path(artigo)
      check 'Excluir arquivo atual'
      fill_in 'Link', with: 'um_link_ai'
      click_button 'Salvar'

      artigo.arquivo.should == nil
    end

    scenario 'alterar arquivo por um novo' do
      submeter_conteudo :artigo_de_evento, link: '',
                        arquivo: File.join(Rails.root, *%w(spec resources arquivo.odt))
      artigo = ArtigoDeEvento.last
      visit edit_conteudo_path(artigo)
      check 'Substituir arquivo atual'
      attach_file 'Arquivo', File.join(Rails.root, *%w(spec resources outro_arquivo.odt))
      click_button 'Salvar'

      artigo.arquivo.nome.should == 'outro_arquivo.odt'
    end
  end
end

