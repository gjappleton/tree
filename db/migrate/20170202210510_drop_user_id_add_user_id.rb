class DropUserIdAddUserId < ActiveRecord::Migration[5.0]
  def change
    remove_column :calls, :user_id
  end
end
