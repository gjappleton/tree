class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      t.integer :phone_number

      t.timestamps
    end
  end
end
