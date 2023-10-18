class Store < ApplicationRecord
  has_many :items, dependent: :destroy

  validates :name, presence: true

  validates :latitude, :longitude, presence: true, numericality: true
  geocoded_by :address
  after_validation :geocode, if: :will_save_change_to_address?

end
