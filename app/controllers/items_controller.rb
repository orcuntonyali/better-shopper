class ItemsController < ApplicationController
  def index
    @items = Item.all
  end

  def show
    @item = Item.find(params[:id])
    @purchase_options = Item.where(name: @item.name).order(unit_price: :asc).limit(5)
    selected_option_index = params[:selected_option_index].to_i
    @selected_option = @purchase_options[selected_option_index]

    render 'show'
  end

  def confirm_selection
    selected_option_id = params[:selected_option_id]
    item_path = params[:item_path]
    redirect_to cart_items_display_cart_items_path(selected_option_id:, item_path:)
  end
end
