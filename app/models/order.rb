class Order < ApplicationRecord
  belongs_to :user
  has_many :cart_items
  
  validates :status, presence: true
  validates :delivery_option, inclusion: { in: [true, false] }
  enum status: [:pending, :shipped, :cancelled]
end
