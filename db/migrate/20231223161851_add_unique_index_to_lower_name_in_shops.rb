class AddUniqueIndexToLowerNameInShops < ActiveRecord::Migration[7.0]
  def change
    add_index :shops, "LOWER(name)", unique: true
  end
end
