def submeter_conteudo(tipo, opcoes)
  visit send(:"new_#{tipo}_path")
  fill_in 'Link', with: opcoes[:link] || 'http://nsi.iff.edu.br'
  fill_in 'Arquivo', with: opcoes[:arquivo] || ''
  click_button 'Salvar'
end
