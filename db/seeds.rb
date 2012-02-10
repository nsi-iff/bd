# encoding: utf-8

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).

def carregar_eixos_tematicos
  ['Artes', 'Ciências', 'Educação', 'Eletrotécnica', 'Eletrônica', 'Filosofia',
   'Física', 'Gestão Ambiental', 'História', 'Informática Educativa',
   'Língua Inglesa', 'Língua Portuguesa', 'Matemática', 'Matemática Básica',
   'Psicologia', 'Química', 'Refrigeração e Climatização',
   'Tecnologia em Informática', 'Telecomunicações', 'Termologia',
   'Todas as Áreas', 'Turismo'].each do |nome_eixo|
    EixoTematico.create! :nome => nome_eixo
  end
end

def carregar_idiomas
  File.read(File.join("#{Rails.root}", 'db', 'seeds', 'idiomas.txt')).each_line do |idioma|
    sigla, descricao = idioma.split(";").map(&:strip)
    Idioma.create! sigla: sigla, descricao: descricao
  end
end

carregar_eixos_tematicos if EixoTematico.count == 0
carregar_idiomas if Idioma.count == 0
