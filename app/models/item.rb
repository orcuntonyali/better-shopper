class Item < ApplicationRecord
  belongs_to :store
  has_many :cart_items

  validates :name, :image_url, :unit_price, presence: true
  validates :unit_price, numericality: { greater_than: 0 }
end
