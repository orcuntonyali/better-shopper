class CartItemsController < ApplicationController
  def new
    @cart_items = []
  end

  def process_audio
    audio_file = params[:audio_file]
    audio_file_path = audio_file.tempfile.path
    transcribed_text = OpenaiService.transcribe(audio_file_path)

    render json: { status: "success", transcribed_text: }
  end

  def process_order
    order_input = params[:order_input]
    processed_order = OpenaiService.process_order(order_input)
    nearest_stores = Store.find_stores_within_distance(
      coordinates: [current_user.latitude, current_user.longitude],
      max_distance: current_user.max_distance || 10
    ).first(5)
    processed_order = find_groceries(processed_order, nearest_stores)
    session[:processed_order] = processed_order
    render json: { status: "success", processed_order: }
  end

  def your_cart
    # These can be obtained from other controllers?
    user = User.find(current_user.id)
    latitude = user.latitude
    longitude = user.longitude
    max_distance = user.max_distance

    processed_order = session[:processed_order]
    # Initialize CartService with the user's latitude and longitude
    cart_service = CartService.new(latitude:, longitude:)

    # Pass max_distance and processed_order to the service
    service_result = cart_service.process_order(processed_order, max_distance)
    raise
    @processed_items = session[:processed_order]
    @not_found_message = service_result['not_found_message']
  end

  def update_cart
    raise
  end

  def create
  end

  def update
  end

  private

  def find_groceries(order_items, stores)
    order_items.map do |order_item|
      find_item(order_item, stores)
    end
  end

  def find_item(order_item, stores)
    item = stores.map do |store|
      store.items.find_by(name: order_item['name'])
    end.min_by(&:unit_price)
    order_item["selected_item"] = item
    order_item
  end

  def find_cheapest_item(order_item, store)
    return [nil, order_item['name']] if store_ids.empty?

    item_name = order_item['name']
    matching_items = Item.where(store:).search_by_name(item_name).order(:unit_price).limit(1).to_a

    return [nil, item_name] if matching_items.empty?

    [matching_items.first, item_name]
  end
end
