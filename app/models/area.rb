class Area < ActiveRecord::Base
	has_many :sub_areas
	
	validates :nome, presence: true, uniqueness: true
end
