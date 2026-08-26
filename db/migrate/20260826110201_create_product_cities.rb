class CreateProductCities < ActiveRecord::Migration[8.1]
  def change
    create_table :product_cities do |t|
      t.references :product, null: false, foreign_key: true
      t.references :city, null: false, foreign_key: true

      t.timestamps
    end
  end
end
