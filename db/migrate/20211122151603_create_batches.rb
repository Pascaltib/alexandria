class CreateBatches < ActiveRecord::Migration[6.1]
  def change
    create_table :batches do |t|
      t.string :name
      t.float :tuition_cost
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
