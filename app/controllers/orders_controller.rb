class OrdersController < ApplicationController
  before_action :authenticate_user!

  def index
    @orders = Order.where(user_id: current_user.id)
  end

  def show
    @order = Order.find_by(id: params[:id])
    if @order.nil?
      flash[:error] = "Order not found."
      # redirect_to new_cart_items_path
    end
    @items = @order.cart_items
    @total_price = @items.map { |item| item.item.unit_price * item.quantity }.sum
    # @delivery_toggle = @order.delivery_option
  end

  # def create
  #   @order = Order.new(user_id: current_user.id, status: :pending, delivery_option: false)
  #   params[:processed_items].each do |item|
  #     @cart_item = CartItem.new(order_id: @order.id, item_id: item[:id], quantity: item[:quantity])
  #     @cart_item.save
  #     @order.cart_items << @cart_item
  #   end
  #   @order.save
  #   redirect_to order_path(@order)
  # end

  def delivery_option
    # manipulate delivery option
  end

  def pickup_locations
    @user = current_user
    @cart_items = CartItem.where(order: @user.orders)
    @items = Item.where(id: @cart_items.pluck(:item_id))
    @stores = Store.where(id: @items.pluck(:store_id))
    # You can also set the user's latitude and longitude here, similar to your homepage.
    @user_address_lat = current_user.latitude
    @user_address_lng = current_user.longitude
    @markers = @stores.geocoded.map do |store|
      {
        lat: store.latitude,
        lng:store.longitude
      }
  end
  end
end
