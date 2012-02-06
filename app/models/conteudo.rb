class Conteudo < ActiveRecord::Base
  has_many :autores
  accepts_nested_attributes_for :autores, :reject_if => :all_blank
end
