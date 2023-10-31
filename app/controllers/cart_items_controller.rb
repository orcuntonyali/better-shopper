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
    Rails.logger.debug "Debugging processed_order: #{processed_order.inspect}"
    session[:processed_order] = processed_order
    render json: { status: "success", processed_order: }
  end

  def display_cart_items
    user = User.find(current_user.id)
    latitude = user.latitude
    longitude = user.longitude
    max_distance = user.max_distance

    processed_order = session[:processed_order]

    # Initialize CartService with the user's latitude and longitude
    cart_service = CartService.new(latitude:, longitude:)

    # Pass max_distance and processed_order to the service
    service_result = cart_service.process_order(processed_order, max_distance)
    @processed_items = service_result['cheapest_items']
    @not_found_message = service_result['not_found_message']
  end

  # def create
  #   item = Item.find(params[:id])
  #   order = current_user.orders.find_or_create_by(status: 'cart')
  #   order.cart_items.create(item: item, quantity: params[:quantity])
  # end

  def update
  end
end
