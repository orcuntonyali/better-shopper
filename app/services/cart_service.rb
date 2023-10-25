class CartService
  def self.process_order(processed_order) # add user_location later
    cheapest_items = []
    not_found_items = []

    processed_order.each do |order_item|
      process_single_order_item(order_item, cheapest_items, not_found_items)
    end

    not_found_message = build_not_found_message(not_found_items)

    {
      'cheapest_items' => cheapest_items,
      'not_found_message' => not_found_message
    }
  end

  def self.process_single_order_item(order_item, cheapest_items, not_found_items)
    cheapest_item, item_name = find_cheapest_item(order_item)

    if cheapest_item
      cheapest_items << format_cheapest_item(cheapest_item, order_item['quantity'])
    else
      not_found_items << item_name
    end
  end

  def self.find_cheapest_item(order_item)
    item_name = order_item['name']
    matching_items = Item.search_by_name(item_name).to_a
    sorted_items = matching_items.sort_by(&:unit_price)
    [sorted_items.first, item_name]
  end

  def self.format_cheapest_item(cheapest_item, item_quantity)
    {
      'id' => cheapest_item.id,
      'name' => cheapest_item.name,
      'price' => cheapest_item.unit_price.to_f,
      'quantity' => item_quantity,
      'store' => cheapest_item.store.name,
      'image_url' => cheapest_item.image_url
    }
  end

  def self.build_not_found_message(not_found_items)
    return unless not_found_items.any?

    "The following items couldn't be found:\n* #{not_found_items.join(",\n* ")}"
  end

  private_class_method :process_single_order_item, :find_cheapest_item, :format_cheapest_item, :build_not_found_message
end
