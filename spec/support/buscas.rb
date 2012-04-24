def buscar_por(conteudo)
  visit "/buscas"
  fill_in "Busca", with: conteudo
  click_button "Buscar"
end

def item_de_busca(options)
  '#resultado li:nth-child(%s) #graos div:nth-child(%s)' % [
    options[:resultado], options[:grao]]
end
