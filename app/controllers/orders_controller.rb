class OrdersController < ApplicationController

  def create

  end

  def show
    @orders = Order.find_by(id: params[:id])
    if @orders.nil?
      flash[:error] = "Order not found."
      # redirect_to display_cart_items_cart_items_path
    end
  end
end
