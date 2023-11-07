class Order < ApplicationRecord
  belongs_to :user
  has_many :cart_items, dependent: :destroy
  has_many :items, through: :cart_items

  enum status: { pending: 0, ordered: 1, shipped: 2, cancelled: 3 }
  enum delivery_option: { pickup: 0, delivery: 1 }

  def total_price
    cart_items.map { |cart_item| cart_item.item.unit_price * cart_item.quantity }.sum
  end
end
