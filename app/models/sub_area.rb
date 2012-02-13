class SubArea < ActiveRecord::Base
	belongs_to :area

	validates :nome, presence: true, uniqueness: true
	validates :area_id, presence: true
	validates_associated :area
end
