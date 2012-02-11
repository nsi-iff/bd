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


#######################  Seeds para Áreas e sub-áreas #######################

Area.delete_all
#Criando Ciências Exatas e da Terra
exatas = Area.create(:nome => 'Ciências Exatas e da Terra')
#Criando sub_areas para exatas
SubArea.delete_all
SubArea.create([
        {:nome => 'Astronomia',                    :area => exatas},
        {:nome => 'Ciência da Computação',         :area => exatas},
        {:nome => 'Física',                        :area => exatas},
        {:nome => 'Geociências',                   :area => exatas},
        {:nome => 'Matemática',                    :area => exatas},
        {:nome => 'Oceanografia',                  :area => exatas},
        {:nome => 'Probabilidade e Estatística',   :area => exatas},
        {:nome => 'Química',                       :area => exatas}
])

#Criando areas biologicas
biologicas = Area.create(:nome => 'Ciências Biológicas')
#Criando sub_areas para biologicas
SubArea.create([
        {:nome => 'Biofísica',        :area => biologicas},
        {:nome => 'Biologia Geral',   :area => biologicas},
        {:nome => 'Bioquimíca',       :area => biologicas},
        {:nome => 'Botânica',         :area => biologicas},
        {:nome => 'Ecologia',         :area => biologicas},
        {:nome => 'Farmacologia',     :area => biologicas},
        {:nome => 'Fisiologia',       :area => biologicas},
        {:nome => 'Genética',         :area => biologicas},
        {:nome => 'Imunologia',       :area => biologicas},
        {:nome => 'Microbiologia',    :area => biologicas},
        {:nome => 'Morfologia',       :area => biologicas},
        {:nome => 'Parasitologia',    :area => biologicas},
        {:nome => 'Zoologia',         :area => biologicas}
])

#Criando areas Engenharias
engenharias = Area.create(:nome => 'Engenharias')
#Criando sub_ares para Engenharias
SubArea.create([
        {:nome => 'Engenharia Aeroespacial',                  :area => engenharias},
        {:nome => 'Engenharia Biomédica',                     :area => engenharias},
        {:nome => 'Engenharia Civil',                         :area => engenharias},
        {:nome => 'Engenharia de Materiais e Metalúrgica',    :area => engenharias},
        {:nome => 'Engenharia de Minas',                      :area => engenharias},
        {:nome => 'Engenharia de Produção',                   :area => engenharias},
        {:nome => 'Engenharia de Transportes',                :area => engenharias},
        {:nome => 'Engenharia Elétrica',                      :area => engenharias},
        {:nome => 'Engenharia Mecânica',                      :area => engenharias},
        {:nome => 'Engenharia Naval e Oceânica',              :area => engenharias},
        {:nome => 'Engenharia Nuclear',                       :area => engenharias},
        {:nome => 'Engenharia Química',                       :area => engenharias},
        {:nome => 'Engenharia Sanitária',                     :area => engenharias}
])

#Criando areas saúde
saude = Area.create(:nome => 'Ciências da Saúde')
#Criando sub_areas para saúde
SubArea.create([
        { :nome => 'Educação Física',                       :area => saude },
        { :nome => 'Enfermagem',                            :area => saude },
        { :nome => 'Farmácia',                              :area => saude },
        { :nome => 'Fisioterapia e Terapia Ocupacional',    :area => saude },
        { :nome => 'Fonoaudiologia',                        :area => saude },
        { :nome => 'Medicina',                              :area => saude },
        { :nome => 'Nutrição',                              :area => saude },
        { :nome => 'Odontologia',                           :area => saude },
        { :nome => 'Saude Coletiva',                        :area => saude }
])

#Criando areas Ciências Agrárias
agrarias = Area.create(:nome => 'Ciências Agrárias')
#Criando sub_areas para Ciências Agrárias
SubArea.create([
        { :nome => 'Agronomia',                                     :area => agrarias },
        { :nome => 'Ciência e Tecnologia de Alimentos',             :area => agrarias },
        { :nome => 'Engenharia Agrícola',                           :area => agrarias },
        { :nome => 'Medicina Veterinária',                          :area => agrarias },
        { :nome => 'Recursos Florestais e Engenharia Florestal',    :area => agrarias },
        { :nome => 'Recursos Pesqueiros e Engenharia de Pesca',     :area => agrarias },
        { :nome => 'Zootecnia',                                     :area => agrarias }
])

#Criando areas Ciências Sociais Aplicadas
sociais_aplicadas = Area.create(:nome => 'Ciências Sociais Aplicadas')
#Criando sub_areas para Ciências Sociais Aplicadas
SubArea.create([
        { :nome => 'Administração',                    :area => sociais_aplicadas },
        { :nome => 'Arquitetura e Urbanismo',          :area => sociais_aplicadas },
        { :nome => 'Ciência da Informação',            :area => sociais_aplicadas },
        { :nome => 'Comunicação',                      :area => sociais_aplicadas },
        { :nome => 'Demografia',                       :area => sociais_aplicadas },
        { :nome => 'Desenho Industrial',               :area => sociais_aplicadas },
        { :nome => 'Direito',                          :area => sociais_aplicadas },
        { :nome => 'Economia',                         :area => sociais_aplicadas },
        { :nome => 'Economia Doméstica',               :area => sociais_aplicadas },
        { :nome => 'Museologia',                       :area => sociais_aplicadas },
        { :nome => 'Planejamento Urbano e Regional',   :area => sociais_aplicadas },
        { :nome => 'Serviço Social',                   :area => sociais_aplicadas },
        { :nome => 'Turismo',                          :area => sociais_aplicadas }
])

#Criando areas Ciências Humanas
humanas = Area.create(:nome => 'Ciências Humanas')
#Criando sub_areas para Ciências Humanas
SubArea.create([
        { :nome => 'Antropologia',         :area => humanas },
        { :nome => 'Arqueologia',          :area => humanas },
        { :nome => 'Ciência Política',     :area => humanas },
        { :nome => 'Educação',             :area => humanas },
        { :nome => 'Filosofia',            :area => humanas },
        { :nome => 'Geografia',            :area => humanas },
        { :nome => 'História',             :area => humanas },
        { :nome => 'Psicologia',           :area => humanas },
        { :nome => 'Sociologia',           :area => humanas },
        { :nome => 'Teologia',             :area => humanas }
])

#Criando areas Linguística, Letras e Artes
linguisticas_letras_e_artes = Area.create(:nome => 'Linguistica, Letras e Artes')
#Criando sub_areas para Linguística, Letras e Artes
SubArea.create([
        { :nome => 'Artes',         :area => linguisticas_letras_e_artes },
        { :nome => 'Letras',        :area => linguisticas_letras_e_artes },
        { :nome => 'Liguística',    :area => linguisticas_letras_e_artes }
])

#Criando areas Outras
outras = Area.create(:nome => 'Outras')
#Criando sub_areas para Outras
SubArea.create([
        { :nome => 'Administração Hospitalar',        :area => outras },
        { :nome => 'Administracao Rural',             :area => outras },
        { :nome => 'Biomedicina',                     :area => outras },
        { :nome => 'Carreira Militar',                :area => outras },
        { :nome => 'Carreira Religiosa',              :area => outras },
        { :nome => 'Ciências',                        :area => outras },
        { :nome => 'Ciências Atuarias',               :area => outras },
        { :nome => 'Ciências Sociais',                :area => outras },
        { :nome => 'Decoração',                       :area => outras },
        { :nome => 'Desenho de Moda',                 :area => outras },
        { :nome => 'Desenho de Projetos',             :area => outras },
        { :nome => 'Diplomacia',                      :area => outras },
        { :nome => 'Engenharia Cartográfica',         :area => outras },
        { :nome => 'Engenharia de Agrimensura',       :area => outras },
        { :nome => 'Engenharia de Armamentos',        :area => outras },
        { :nome => 'Engenharia Mecatrônica',          :area => outras },
        { :nome => 'Engenharia Têxtil',               :area => outras },
        { :nome => 'Estudos Sociais',                 :area => outras },
        { :nome => 'História Natural',                :area => outras },
        { :nome => 'Multidisciplinar',                :area => outras },
        { :nome => 'Química Industrial',              :area => outras },
        { :nome => 'Relações Internacionais',         :area => outras },
        { :nome => 'Relações Públicas',               :area => outras },
        { :nome => 'Secretariado Executivo',          :area => outras },
        { :nome => 'Outra',                           :area => outras }
])
