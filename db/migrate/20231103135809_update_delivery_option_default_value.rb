class UpdateDeliveryOptionDefaultValue < ActiveRecord::Migration[7.0]
  def change
    remove_column :orders, :delivery_option
    add_column :orders, :delivery_option, :integer, default: 0
  end
end
