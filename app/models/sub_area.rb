class SubArea < ActiveRecord::Base
	belongs_to :area

	validates_presence_of :nome
	validates_uniqueness_of :nome
	validates_presence_of :area_id
	validates_associated :area
end
