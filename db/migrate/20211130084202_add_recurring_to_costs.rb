class AddRecurringToCosts < ActiveRecord::Migration[6.1]
  def change
    add_column :costs, :recurring, :string
  end
end
