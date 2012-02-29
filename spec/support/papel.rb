# encoding: utf-8

def criar_papeis
  Papel.destroy_all
  membro = Papel.create(nome: 'membro')
  contribuidor_de_conteudo = Papel.create(nome: 'contribuidor de conteúdo')
  gestor_de_conteudo = Papel.create(nome: 'gestor de conteúdo')
  administrador = Papel.create(nome: 'administrador')
end
