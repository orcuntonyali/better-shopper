class CartService
  def initialize(latitude:, longitude:)
    @latitude = latitude
    @longitude = longitude
  end

  def process_order(processed_order, max_distance)
    cheapest_items = []
    not_found_items = []
    stores_within_distance = find_stores_within_distance(max_distance)

    processed_order&.each do |order_item|
      process_single_order_item(order_item, cheapest_items, not_found_items, stores_within_distance)
    end

    not_found_message = build_not_found_message(not_found_items)

    {
      'cheapest_items' => cheapest_items,
      'not_found_message' => not_found_message
    }
  end

  private

  def process_single_order_item(order_item, cheapest_items, not_found_items, stores_within_distance)
    cheapest_item, item_name = find_cheapest_item(order_item, stores_within_distance)

    if cheapest_item
      cheapest_items << format_cheapest_item(cheapest_item, order_item['quantity'])
    else
      not_found_items << item_name
    end
  end

  def find_stores_within_distance(max_distance)
    Store.near([@latitude, @longitude], max_distance, units: :km).to_a
  end

  def find_cheapest_item(order_item, store_ids)
    return [nil, order_item['name']] if store_ids.empty?

    item_name = order_item['name']
    matching_items = Item.where(store_id: store_ids).search_by_name(item_name).order(:unit_price).limit(1).to_a

    return [nil, item_name] if matching_items.empty?

    [matching_items.first, item_name]
  end

  def format_cheapest_item(cheapest_item, item_quantity)
    {
      'id' => cheapest_item.id,
      'name' => cheapest_item.name,
      'price' => cheapest_item.unit_price.to_f,
      'quantity' => item_quantity,
      'store' => cheapest_item.store.name,
      'image_url' => cheapest_item.image_url
    }
  end

  def build_not_found_message(not_found_items)
    return unless not_found_items.any?

    "The following items couldn't be found:\n* #{not_found_items.join(",\n* ")}"
  end
end
