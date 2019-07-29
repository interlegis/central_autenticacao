class CreateApiAccessesLevels < ActiveRecord::Migration[5.2]
  def change
    create_table :api_accesses_levels do |t|
      t.string :name

      t.timestamps
    end
  end
end
