class RemoveTypeFromCosts < ActiveRecord::Migration[6.1]
  def change
    remove_column :costs, :type
  end
end
