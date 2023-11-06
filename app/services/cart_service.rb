class CartService
  def initialize(stores_within_distance:)
    @stores_within_distance = stores_within_distance
    @cheapest_items = []
    @not_found_items = []
  end

  def process_order(processed_order, order)
    prepare_list(processed_order)

    create_cart_items(@cheapest_items, order) if @cheapest_items.present?

    {
      'cheapest_items' => @cheapest_items,
      'not_found_message' => not_found_message(@not_found_items)
    }
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
    Item.joins(:store)
        .where(stores: { id: @stores_within_distance.map(&:id) })
        .search_by_name(item_name)
        .order(:unit_price)
        .last
  end

  def not_found_message(not_found_items)
    return if not_found_items.empty?

    "The following items couldn't be found:\n* #{not_found_items.join("\n* ")}"
  end
end
