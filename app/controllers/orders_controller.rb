class OrdersController < ApplicationController

  def show
    @cart_items = @order.cart_items if @order
  end

  def create
  end

  def delivery
  end
end