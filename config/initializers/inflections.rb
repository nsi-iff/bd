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
#   inflect.plural /^(ox)$/i, '\1en'
#   inflect.singular /^(ox)en/i, '\1'
#   inflect.irregular 'person', 'people'
#   inflect.uncountable %w( fish sheep )
end
#
# These inflection rules are supported but not enabled by default:
# ActiveSupport::Inflector.inflections do |inflect|
#   inflect.acronym 'RESTful'
# end
