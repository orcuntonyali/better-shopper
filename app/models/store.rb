class Store < ApplicationRecord
  has_many :items, dependent: :destroy

  validates :name, presence: true
  geocoded_by :address
  after_validation :geocode, if: :will_save_change_to_address?

  def self.find_stores_within_distance(attr = {})
    near(attr[:coordinates], attr[:max_distance], units: :km).to_a
  end
end
