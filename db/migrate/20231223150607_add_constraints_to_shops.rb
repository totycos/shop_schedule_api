# frozen_string_literal: true

# Migration to add constrainsts to shops
class AddConstraintsToShops < ActiveRecord::Migration[7.0]
  def change
    add_index :shops, :name, unique: true
    change_column :shops, :name, :string, null: false
  end
end
