class CreateAddresses < ActiveRecord::Migration[6.1]
  def change
    create_table :addresses do |t|
      t.string :name
      t.decimal :latitude
      t.decimal :longtitude
      t.text :address
      t.text :description

      t.timestamps
    end
  end
end
