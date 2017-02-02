class AddColumnsToCalls < ActiveRecord::Migration[5.0]
  def change
    add_column :calls, :phone_number, :integer, limit: 8
  end
end
