class Idioma < ActiveRecord::Base
  default_scope :order => 'descricao'
end
