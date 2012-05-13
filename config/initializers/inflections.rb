# Be sure to restart your server when you modify this file.

# Add new inflection rules using the following format
# (all these examples are active by default):
ActiveSupport::Inflector.inflections do |inflect|
  inflect.plural /or$/i, 'ores'
  inflect.singular /ores$/i, 'or'
  inflect.irregular 'artigo_de_evento', 'artigos_de_evento'
  inflect.irregular 'ArtigoDeEvento', 'ArtigosDeEvento'
  inflect.irregular 'artigo_de_periodico', 'artigos_de_periodico'
  inflect.irregular 'ArtigoDePeriodico', 'ArtigosDePeriodico'
  inflect.irregular 'periodico_tecnico_cientifico', 'periodicos_tecnico_cientificos'
  inflect.irregular 'PeriodicoTecnicoCientifico', 'PeriodicosTecnicoCientificos'
  inflect.irregular 'ObjetoDeAprendizagem', 'ObjetosDeAprendizagem'
  inflect.irregular 'objeto_de_aprendizagem', 'objetos_de_aprendizagem'
  inflect.irregular 'EixoTematico', 'EixosTematicos'
  inflect.irregular 'eixo_tematico', 'eixos_tematicos'
  inflect.irregular 'TrabalhoDeObtencaoDeGrau', 'TrabalhosDeObtencaoDeGrau'
  inflect.irregular 'trabalho_de_obtencao_de_grau', 'trabalhos_de_obtencao_de_grau'
  inflect.irregular 'MudancaDeEstado', 'MudancasDeEstado'
  inflect.irregular 'mudanca_de_estado', 'mudancas_de_estado'
  inflect.plural /cao$/i, 'coes'
  inflect.singular /coes$/i, 'cao'
  inflect.uncountable %w(campus cesta)
  inflect.plural /el$/i, 'eis'
  inflect.singular /eis$/i, 'el'
  inflect.singular /ais$/i, 'al'
end
