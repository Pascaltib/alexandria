class CreateCosts < ActiveRecord::Migration[6.1]
  def change
    create_table :costs do |t|
      t.string :name
      t.string :type
      t.float :amount
      t.references :batch, null: false, foreign_key: true

      t.timestamps
    end
  end
end
