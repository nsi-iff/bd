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

Area.delete_all
exatas = Area.create(:nome => 'Ciências Exatas e da Terra')

#sub_areas de exatas
SubArea.delete_all
SubArea.create([{:nome => 'Astronomia', 								 :area => exatas},
								{:nome => 'Ciência da Computação', 			 :area => exatas},
								{:nome => 'Física', 										 :area => exatas},
								{:nome => 'Geociências', 								 :area => exatas},
								{:nome => 'Matemática', 								 :area => exatas},
								{:nome => 'Oceanografia', 							 :area => exatas},
								{:nome => 'Probabilidade e Estatística', :area => exatas},
								{:nome => 'Química', 										 :area => exatas}		
				])

#Criando areas biologicas
biologicas = Area.create(:nome => 'Ciências Biológicas')

#criando sub_areas p biologicas
SubArea.create([{:nome => 'Biofísica', 			:area => biologicas},
								{:nome => 'Biologia Geral', :area => biologicas},
								{:nome => 'Bioquimíca', 		:area => biologicas},
								{:nome => 'Botânica', 			:area => biologicas},
								{:nome => 'Ecologia', 			:area => biologicas},
								{:nome => 'Farmacologia', 	:area => biologicas},
								{:nome => 'Fisiologia', 		:area => biologicas},
								{:nome => 'Genética', 			:area => biologicas},
								{:nome => 'Imunologia', 		:area => biologicas},
								{:nome => 'Microbiologia', 	:area => biologicas},
								{:nome => 'Morfologia', 		:area => biologicas},
								{:nome => 'Parasitologia', 	:area => biologicas},
								{:nome => 'Zoologia', 			:area => biologicas}

				])

engenharias = Area.create(:nome => 'Engenharias')
SubArea.create([{:nome => 'Engenharia Aeroespacial', 								:area => engenharias},
								{:nome => 'Engenharia Biomédica', 									:area => engenharias},
								{:nome => 'Engenharia Civil', 											:area => engenharias},
								{:nome => 'Engenharia de Materiais e Metalúrgica', 	:area => engenharias},
								{:nome => 'Engenharia de Minas', 										:area => engenharias},
								{:nome => 'Engenharia de Produção', 								:area => engenharias},
								{:nome => 'Engenharia de Transportes', 							:area => engenharias},
								{:nome => 'Engenharia Elétrica', 										:area => engenharias},
								{:nome => 'Engenharia Mecânica', 										:area => engenharias},
								{:nome => 'Engenharia Naval e Oceânica', 						:area => engenharias},
								{:nome => 'Engenharia Nuclear', 										:area => engenharias},
								{:nome => 'Engenharia Química', 										:area => engenharias},
								{:nome => 'Engenharia Sanitária', 									:area => engenharias}
				])

saude = Area.create(:nome => 'Ciências da Saúde')
SubArea.create([
			{ :nome => 'Educação Física', 										:area => saude },
			{ :nome => 'Enfermagem', 													:area => saude },
			{ :nome => 'Farmácia', 														:area => saude },
			{ :nome => 'Fisioterapia e Terapia Ocupacional', 	:area => saude },
			{ :nome => 'Fonoaudiologia', 											:area => saude },
			{ :nome => 'Medicina', 														:area => saude },
			{ :nome => 'Nutrição', 														:area => saude },
			{ :nome => 'Odontologia', 												:area => saude },
			{ :nome => 'Saude Coletiva', 											:area => saude }
				])

agrarias = Area.create(:nome => 'Ciências Agrárias')
SubArea.create([
				{ :nome => 'Agronomia', 																	:area => agrarias },
				{ :nome => 'Ciência e Tecnologia de Alimentos', 					:area => agrarias },
				{ :nome => 'Engenharia Agrícola', 												:area => agrarias },
				{ :nome => 'Medicina Veterinária', 												:area => agrarias },
				{ :nome => 'Recursos Florestais e Engenharia Florestal', 	:area => agrarias },
				{ :nome => 'Recursos Pesqueiros e Engenharia de Pesca', 	:area => agrarias },
				{ :nome => 'Zootecnia', 																	:area => agrarias }
				])
