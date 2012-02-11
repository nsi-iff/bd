class Area < ActiveRecord::Base
	has_many :sub_areas

	validates_presence_of :nome
	validates_uniqueness_of :nome
end
