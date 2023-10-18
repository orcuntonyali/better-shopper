class Store < ApplicationRecord
  has_many :items

  validates :name, presence: true
  validates :latitude, :longitude, presence: true, numericality: true
end
