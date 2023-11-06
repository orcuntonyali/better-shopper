class CartItemsController < ApplicationController
  before_action :set_cart_service_variables, only: [:process_order, :my_cart]

  def new
  end

  def process_audio
    audio_file = params[:audio_file]
    audio_file_path = audio_file.tempfile.path
    transcribed_text = OpenaiService.transcribe(audio_file_path)

    render json: { status: "success", transcribed_text: }
  end

  def process_order
    order_input = params[:order_input]
    # Initialize OpenaiService
    processed_order = OpenaiService.process_order(order_input)
    render json: { status: "success", processed_order: }

    # Create a new order for the user
    order = Order.create(user: current_user, delivery_option: :pickup, status: :pending)

    # Initialize CartService
    cart_service = CartService.new(latitude: @latitude, longitude: @longitude)
    cart_service.process_order(processed_order, @max_distance, order)
  end

  def my_cart
    @order = current_user.orders.last
    @processed_items = @order.cart_items
    # @not_found_message = @order.not_found_message  # You may need to store this message in the Order model
    # cart_item = CartItem.find(params[:id])
    # name = cart_item.name
  end

  def update_cart
    # Find the cart item by ID from the form submission
    cart_item = CartItem.find(params[:id])
    # Update the quantity of the cart item
    quantity = cart_item.quantity + params[:change].to_i
    if cart_item.update(quantity:)
      render json: { status: "success" }
    else
      render json: { status: "error" }
    end
  end

  private

  def set_cart_service_variables
    user = User.find(current_user.id)
    @latitude = user.latitude
    @longitude = user.longitude
    @max_distance = user.max_distance
    @stores = Store.near([@latitude, @longitude], @max_distance, units: :km).to_a
  end
end
