# frozen_string_literal: true

# Migration to add unique index to lower name in shops
class AddUniqueIndexToLowerNameInShops < ActiveRecord::Migration[7.0]
  def change
    add_index :shops, 'LOWER(name)', unique: true
  end
end
