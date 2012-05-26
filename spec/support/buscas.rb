def item_de_busca(options)
  '#resultado li:nth-child(%s) #graos div:nth-child(%s)' % [
    options[:resultado], options[:grao]]
end
