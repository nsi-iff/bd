class SubArea < ActiveRecord::Base
	belongs_to :area
	has_many :conteudos

	validates :nome, presence: true, uniqueness: true
	validates :area_id, presence: true
	validates_associated :area

	def to_s
		self.nome	
	end
end
