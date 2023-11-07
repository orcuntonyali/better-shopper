class AddOrderIdentifierToOrders < ActiveRecord::Migration[7.0]
  def change
    add_column :orders, :order_identifier, :string
    add_index :orders, :order_identifier, unique: true
  end
end
