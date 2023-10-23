class CartService
  def self.process_order(processed_order)
    cheapest_items = []
    not_found_items = []

    processed_order.each do |order_item|
      item_name = order_item['name']
      item_quantity = order_item['quantity']

      # Using pg_search scope for partial and fuzzy match
      matching_items = Item.search_by_name(item_name)

      # Sorting the matching items by price and picking the cheapest one
      cheapest_item = matching_items.order(:unit_price).first

      if cheapest_item.present?
        cheapest_items << {
          'name' => cheapest_item.name,
          'price' => cheapest_item.unit_price.to_f,
          'quantity' => item_quantity,
          'store' => cheapest_item.store.name,
          'image_url' => cheapest_item.image_url
        }
      else
        # Accumulating names of not found items
        not_found_items << item_name
      end
    end

    if not_found_items.any?
      not_found_message = "The following items couldn't be found:\n* " + not_found_items.join(",\n* ")
    end

    {
      'cheapest_items' => cheapest_items,
      'not_found_message' => not_found_message
    }
  end
end
