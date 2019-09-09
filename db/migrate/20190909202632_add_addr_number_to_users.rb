class AddAddrNumberToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :addr_number, :integer
  end
end
