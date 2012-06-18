class Idioma < ActiveRecord::Base
  default_scope order: 'descricao'

  attr_accessible :descricao, :sigla
end
