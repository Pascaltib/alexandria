class AddKindToCosts < ActiveRecord::Migration[6.1]
  def change
    add_column :costs, :kind, :string
  end
end
