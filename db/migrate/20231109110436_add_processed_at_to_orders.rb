class AddProcessedAtToOrders < ActiveRecord::Migration[7.0]
  def change
    add_column :orders, :processed_at, :datetime
  end
end
