# encoding: utf-8

require 'spec_helper'

feature 'Editar Conteúdo' do
  context 'conteúdo em estado pendente ou recolhido' do
    scenario 'editar conteúdo' do
      Papel.criar_todos
      usuario = autenticar_usuario(Papel.contribuidor)

      tipos_de_conteudo.each do |tipo|
        conteudo = create(tipo, contribuidor: usuario)
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
      submeter_conteudo :livro, link: '',
                         arquivo: File.join(Rails.root, *%w(spec resources arquivo.odt))
      livro = Livro.last
      visit edit_conteudo_path(livro)
      link = find_link "Download: #{livro.arquivo.nome}"
      link["href"].should == livro.link_download
    end

    scenario 'remover arquivo atual' do
      submeter_conteudo :livro, link: '',
                        arquivo: File.join(Rails.root, *%w(spec resources arquivo.odt))
      livro = Livro.last
      visit edit_conteudo_path(livro)
      check 'Excluir arquivo atual'
      fill_in 'Link', with: 'um_link_ai'
      click_button 'Salvar'

      livro.arquivo.should == nil
    end

    scenario 'alterar arquivo por um novo' do
      submeter_conteudo :livro, link: '',
                        arquivo: File.join(Rails.root, *%w(spec resources arquivo.odt))
      livro = Livro.last
      visit edit_conteudo_path(livro)
      check 'Substituir arquivo atual'
      attach_file 'Arquivo', File.join(Rails.root, *%w(spec resources outro_arquivo.odt))
      click_button 'Salvar'

      livro.arquivo.nome.should == 'outro_arquivo.odt'
    end
  end
end
