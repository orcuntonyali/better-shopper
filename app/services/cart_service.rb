class CartService
  def self.process_order(processed_order) # add user_location later
    cheapest_items = []
    not_found_items = []

    processed_order.each do |order_item|
      item_name = order_item['name']
      item_quantity = order_item['quantity']

      # Using pg_search scope for partial and fuzzy match
      matching_items = Item.search_by_name(item_name).to_a

      # Placeholder for sorting by proximity logic (to be implemented later)
      # For now, it has no effect
      # matching_items = sort_by_proximity(matching_items, user_location)

      # Sorting the items by unit price
      sorted_items = matching_items.sort_by { |item| item.unit_price }

      # Picking the cheapest item
      cheapest_item = sorted_items.first

      if cheapest_item.present?
        cheapest_items << {
          'id' => cheapest_item.id,
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

  # Placeholder for proximity sorting method
  def self.sort_by_proximity(matching_items, user_location)
    # TODO: Implement proximity sorting logic
    matching_items
  end
end
