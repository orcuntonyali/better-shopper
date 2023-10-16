class Order < ApplicationRecord
  belongs_to :user
  has_many :cart_items

  validates :status, presence: true, inclusion: { in: [some_array_of_valid_statuses] }
  validates :delivery_option, inclusion: { in: [true, false] }
end
