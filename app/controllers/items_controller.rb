class ItemsController < ApplicationController
  def index
    @items = Item.all
  end

  def show
    @item = Item.find(params[:id])
    @purchase_options = Item.where(name: @item.name).order(unit_price: :asc).limit(5)
    render 'show'
  end
end
