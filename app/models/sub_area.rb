class SubArea < ActiveRecord::Base
  belongs_to :area
  has_many :conteudos

  attr_accessible :nome, :area

  validates :nome, presence: true, uniqueness: true
  validates :area_id, presence: true
  validates_associated :area

  def to_s
    nome
  end

  def nome_area
    area.nome
  end
end
