class OrdersController < ApplicationController

  def show
    @orders = Order.find_by(id: params[:id])
    if @orders.nil?
      flash[:error] = "Order not found."
      # redirect_to new_cart_items_path
    end
    @items = @order.items
    @total_price = @items.sum(:price)
  end

  def create
  end

  def delivery
  end
end