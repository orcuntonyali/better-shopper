class OrdersController < ApplicationController
  before_action :authenticate_user!

  def index
    @orders = Order.where(user_id: current_user.id).order(created_at: :desc).ordered
  end

  def show
    @order = Order.find_by(id: params[:id])
    if @order.nil?
      flash[:error] = "Order not found."
      # redirect_to new_cart_items_path
    end
    @items = @order.cart_items
    @delivery_toggle = @order.delivery_option
    @service_fee = 5.00
    @delivery_fee = 5.00
  end

  def destroy
    @order = Order.find(params[:id])
    @order.destroy
    redirect_to orders_path, notice: 'Order was successfully cancelled.'
  end

  def delivery_option
    # manipulate delivery option
  end

  def pickup_locations
    @order = Order.find(params[:id])
    @order.ordered!
    @user = current_user
    @cart_items = CartItem.where(order: @order)
    @items = Item.where(id: @cart_items.pluck(:item_id))
    @stores = Store.where(id: @items.pluck(:store_id))
    # You can also set the user's latitude and longitude here, similar to your homepage.
    @user_address_lat = current_user.latitude
    @user_address_lng = current_user.longitude
    @markers = @stores.geocoded.map do |store|
      {
        lat: store.latitude,
        lng:store.longitude,
        marker_color: 'gray'
      }
    end
  end
end
