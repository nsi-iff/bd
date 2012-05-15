# encoding: utf-8

def papel(nome)
  Papel.where(nome: nome).present? || Papel.create!(nome: nome, descricao: 'dummy')
end

def acesso_negado
  'Acesso negado'
end
