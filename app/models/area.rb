class Area < ActiveRecord::Base
  has_many :sub_areas
  has_many :conteudos

  attr_accessible :nome

  validates :nome, presence: true, uniqueness: true

  def conteudos
    self.sub_areas.map(&:conteudos).flatten
  end

  def to_s
    self.nome
  end

  def underscored_nome
    self.nome.removeaccents.titleize.delete(" ").underscore
  end
end
