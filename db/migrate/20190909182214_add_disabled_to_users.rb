class AddDisabledToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :disabled, :boolean
  end
end
