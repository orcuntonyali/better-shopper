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
    p processed_order

    # Create order for the user
    order = Order.create(user: current_user, delivery_option: :pickup, status: :pending)
    puts order # This is just to see the order in the console

    # Initialize cart_service.rb
    cart_service = CartService.new(stores_within_distance: @stores_within_distance)
    result = cart_service.process_order(processed_order, order)

    # Respond with the processed order data and redirect URL for successful AJAX request
    if result['cheapest_items'].present?
      render json: { status: "success", processed_order:, redirect_url: my_cart_cart_items_path }
    else
      render json: { status: "error", message: result['not_found_message'] }
    end
  end

  def my_cart
    @order = current_user.orders.last
    @cart_items = @order.cart_items
    # replace_cart_item
  end

  def update_cart
    # Find cart item by ID from the form submission
    cart_item = CartItem.find(params[:id])
    # Update quantity of the cart item on the fly
    quantity = cart_item.quantity + params[:change].to_i
    if cart_item.update(quantity:)
      render json: { status: "success" }
    else
      render json: { status: "error" }
    end
  end

  def edit
    @cart_item = CartItem.find(params[:id])
    @item = @cart_item.item
    @purchase_options = Item.where(name: @item.name).order(unit_price: :asc).limit(5)
  end

  def update
    @cart_item = CartItem.find(params[:id])
    @cart_item.update(cart_item_params)
    redirect_to my_cart_cart_items_path
  end

  private

  def cart_item_params
    params.require(:cart_item).permit(:item_id)
  end

  def set_cart_service_variables
    user = User.find(current_user.id)
    @latitude = user.latitude
    @longitude = user.longitude
    @max_distance = 2 # change this to user.max_distance later
    @stores_within_distance = Store.near([@latitude, @longitude], @max_distance, units: :km).to_a
  end
end
