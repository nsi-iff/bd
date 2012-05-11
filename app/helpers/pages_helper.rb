module PagesHelper
  def link_to_manual(titulo, nome_arquivo)
    link_to "#{titulo}", "/arquivos/manuais/#{nome_arquivo}", target: "_blank"
  end

  def link_to_tutorial(titulo, nome_arquivo)
    link_to "#{titulo}", "/arquivos/tutoriais/#{nome_arquivo}", target: "_blank"
  end
end
