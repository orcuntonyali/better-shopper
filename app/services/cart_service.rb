class CartService
  def initialize(stores_within_distance:)
    @stores_within_distance = stores_within_distance
    @cheapest_items = []
    @not_found_items = []
  end

  def process_order(processed_order, order)
    prepare_list(processed_order)

    if @cheapest_items.present?
      create_cart_items(@cheapest_items, order)

      # Assuming your Order model has a method to mark it as processed
      mark_order_as_processed(order)

      return {
        'cheapest_items' => @cheapest_items,
        'not_found_message' => not_found_message(@not_found_items)
      }
    else
      # You may need to handle the case where there are no cheapest items found
      return {
        'cheapest_items' => [],
        'not_found_message' => "No items found."
      }
    end
  end

  private

  def prepare_list(processed_order)
    processed_order&.each do |order_item|
      item_name = order_item['name']
      cheapest_item = search_for_cheapest_item(item_name)

      if cheapest_item
        @cheapest_items << { item: cheapest_item, quantity: order_item['quantity'] }
      else
        @not_found_items << item_name
      end
    end
  end

  def create_cart_items(cheapest_items, order)
    ActiveRecord::Base.transaction do
      cheapest_items.each do |cheapest_item|
        CartItem.create!(
          order: order,
          item: cheapest_item[:item],
          quantity: cheapest_item[:quantity]
        )
      end
    end
  end

  def search_for_cheapest_item(item_name)
    item = Item.joins(:store)
        .where(stores: { id: @stores_within_distance.pluck(:id) })
        .where("items.name ILIKE ?", "%#{item_name}%")
        .order(:unit_price)
        .first
  end

  def not_found_message(not_found_items)
    return if not_found_items.empty?

    "The following items couldn't be found:\n* #{not_found_items.join("\n* ")}"
  end

 # In CartService:
  def mark_order_as_processed(order)
    order.update(status: :ordered, processed_at: Time.current)
  end
end
