# encoding: utf-8

def criar_papeis
  Papel.delete_all
  Papel.criar_todos
end

def papel(nome)
  Papel.where(nome: nome).present? || Papel.create!(nome: nome, descricao: 'dummy')
end

def acesso_negado
  'Acesso negado'
end
