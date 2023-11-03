class Order < ApplicationRecord
  belongs_to :user
  has_many :cart_items

  enum status: { pending: 0, ordered: 1, shipped: 2, cancelled: 3 }
  enum delivery_option: { pickup: 0, delivery: 1 }

  validates :status, inclusion: { in: statuses.keys }
  validates :delivery_option, inclusion: { in: delivery_options.keys }
end
