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

  context 'download na página de editar' do
    scenario 'link para download com o nome do arquivo' do
      Papel.criar_todos
      submeter_conteudo :artigo_de_evento, link: '', arquivo: File.join(Rails.root, *%w(spec resources arquivo.odt))
      artigo = ArtigoDeEvento.last
      autenticar(artigo.contribuidor)
      visit edit_conteudo_path(artigo)
      click_link "Download: #{artigo.arquivo.nome}"
      baixado = "#{Rails.root}/tmp/#{artigo.titulo}.odt"
      postado = "#{Rails.root}/spec/resources/arquivo.odt"
      FileUtils.compare_file(baixado, postado).should == true
    end
  end
end
