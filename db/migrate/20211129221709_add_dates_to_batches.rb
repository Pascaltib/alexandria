class AddDatesToBatches < ActiveRecord::Migration[6.1]
  def change
    add_column :batches, :start_date, :date
    add_column :batches, :end_date, :date
  end
end
