def item_de_busca(options)
  '#resultado li:nth-child(%s) #graos div:nth-child(%s)' % [
    options[:resultado], options[:grao]]
end

def aprovar(*conteudos)
  conteudos.each do |conteudo|
    conteudo.submeter! if conteudo.editavel?
    conteudo.aprovar! if conteudo.pendente?
  end
end
