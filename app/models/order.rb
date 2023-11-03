class Order < ApplicationRecord
  belongs_to :user
  has_many :cart_items

  enum status: { pending: 0, ordered: 1, shipped: 2, cancelled: 3 }
  enum delivery_option: { pickup: 0, delivery: 1 }
end
