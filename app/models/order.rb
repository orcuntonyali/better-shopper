class Order < ApplicationRecord
  belongs_to :user
  has_many :cart_items, dependent: :destroy
  has_many :items, through: :cart_items

  enum status: { pending: 0, ordered: 1, shipped: 2, cancelled: 3 }
  enum delivery_option: { pickup: 0, delivery: 1 }

  before_create :set_order_identifier

  def total_price
    cart_items.map { |cart_item| cart_item.item.unit_price * cart_item.quantity }.sum
  end

  private

  def set_order_identifier
    self.order_identifier = generate_order_id(user_id)
  end

  def generate_order_id(user_id)
    unique_component = user_id.to_s(16) # Convert to hexadecimal for brevity
    random_component = SecureRandom.hex(3) # Generates 6 hexadecimal characters
    random_digit = rand(0..9)
    order_id = "#{random_digit}#{unique_component}#{random_component}".upcase

    # Ensure the generated order ID is unique across orders
    return order_id unless Order.exists?(order_identifier: order_id)

    # If it's not unique, try again
    generate_order_id(user_id)
  end
end
