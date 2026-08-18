class AddSizesToProducts < ActiveRecord::Migration[8.1]
  def change
    add_column :products, :sizes, :text
  end
end
