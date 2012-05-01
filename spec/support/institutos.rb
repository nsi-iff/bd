# encoding: utf-8

def campus_nao_federais
  nenhum_instituto = Instituicao.create(nome: 'Não pertenço a nenhum Instituto Federal')
  nenhum_instituto.campus.create(nome: '----')

  outro_instituto = Instituicao.create(nome: 'Outro')
  outro_instituto.campus.create(nome: 'Outro')

  [outro_instituto.campus, nenhum_instituto.campus]
end
