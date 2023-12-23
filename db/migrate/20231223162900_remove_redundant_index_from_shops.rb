class RemoveRedundantIndexFromShops < ActiveRecord::Migration[7.0]
  def change
    remove_index "shops", name: "index_shops_on_name"
  end
end
