# encoding: utf-8

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).

['Artes', 'Ciências', 'Educação', 'Eletrotécnica', 'Eletrônica', 'Filosofia',
 'Física', 'Gestão Ambiental', 'História', 'Informática Educativa',
 'Língua Inglesa', 'Língua Portuguesa', 'Matemática', 'Matemática Básica',
 'Psicologia', 'Química', 'Refrigeração e Climatização',
 'Tecnologia em Informática', 'Telecomunicações', 'Termologia',
 'Todas as Áreas', 'Turismo'].each do |nome_eixo|
  EixoTematico.create! :nome => nome_eixo
end
