class Area < ActiveRecord::Base
  has_many :sub_areas
  has_many :conteudos

  attr_accessible :nome

  validates :nome, presence: true, uniqueness: true

  def to_s
    self.nome
  end
end
