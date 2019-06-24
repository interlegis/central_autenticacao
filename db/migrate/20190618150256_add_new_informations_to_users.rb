class AddNewInformationsToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :cpf, :string
    add_column :users, :birth_date, :date
    add_column :users, :cep, :string
    add_column :users, :state, :string
    add_column :users, :city, :string
    add_column :users, :address, :string
  end
end
