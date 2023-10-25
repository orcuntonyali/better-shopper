class CartService
  def initialize(latitude:, longitude:)
    @latitude = latitude
    @longitude = longitude
  end

  def process_order(processed_order, max_distance)
    cheapest_items = []
    not_found_items = []
    stores_within_distance = find_stores_within_distance(max_distance)

    processed_order.each do |order_item|
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

  # def find_stores_within_distance(max_distance)
  #   # Fetch stores within the given distance
  #   stores_within_distance = Store.near([@latitude, @longitude], max_distance, units: :km).to_a

  #   # Extract the IDs from the Store objects
  #   store_ids = stores_within_distance.map(&:id)

  #   # Now, you can return both or use 'store_ids' as needed
  #   [stores_within_distance, store_ids]
  # end

  def find_stores_within_distance(max_distance)
    # Fetch stores within the given distance
    Store.near([@latitude, @longitude], max_distance, units: :km).to_a
  end

  # def find_cheapest_item(order_item, stores_within_distance)
  #   item_name = order_item['name']
  #   matching_items = Item.joins(:store).where(stores: { id: stores_within_distance.ids }).search_by_name(item_name).to_a
  #   sorted_items = matching_items.sort_by(&:unit_price)
  #   [sorted_items.first, item_name]
  # end

  # def find_cheapest_item(order_item, stores_within_distance)
  #   puts "Order item: #{order_item}"  # Debug line
  #   puts "Stores within distance: #{stores_within_distance}"  # Debug line

  #   item_name = order_item['name']

  #   store_ids = stores_within_distance.map(&:id)
  #   puts "Store IDs: #{store_ids}"  # Debug line

  #   matching_items = Item.joins(:store).where(stores: { id: store_ids }).search_by_name(item_name).to_a

  #   puts "Matching items: #{matching_items}"  # Debug line

  #   sorted_items = matching_items.sort_by(&:unit_price)
  #   [sorted_items.first, item_name]
  # end

  # def find_cheapest_item(order_item, stores_within_distance)
  #   return [nil, order_item['name']] unless stores_within_distance&.respond_to?(:map)

  #   item_name = order_item['name']

  #   store_ids = stores_within_distance.map(&:id)
  #   puts "Store IDs: #{store_ids}"  # Debug line (remove after debugging)

  #   matching_items = Item.joins(:store).where(stores: { id: store_ids }).search_by_name(item_name).to_a

  #   puts "Matching items: #{matching_items}"  # Debug line (remove after debugging)

  #   sorted_items = matching_items.sort_by(&:unit_price)
  #   [sorted_items.first, item_name]
  # end

  def find_cheapest_item(order_item, stores_within_distance)
    return [nil, order_item['name']] if stores_within_distance.nil? || !stores_within_distance.respond_to?(:map)

    item_name = order_item['name']
    return [nil, item_name] if item_name.nil?

    store_ids = stores_within_distance.map(&:id)
    puts "Store IDs: #{store_ids}"

    matching_items = Item.joins(:store).where(stores: { id: store_ids }).search_by_name(item_name).to_a
    puts "Matching items: #{matching_items}"

    return [nil, item_name] if matching_items.empty?

    sorted_items = matching_items.sort_by do |item|
      item.respond_to?(:unit_price) ? item.unit_price : Float::INFINITY
    end

    [sorted_items.first, item_name]
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
