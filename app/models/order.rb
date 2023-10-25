class Order < ApplicationRecord
  belongs_to :user
  has_many :cart_items

  validates :status, presence: true, inclusion: { in: [:pending, :shipped, :cancelled] }
  validates :delivery_option, inclusion: { in: [true, false] }
end
