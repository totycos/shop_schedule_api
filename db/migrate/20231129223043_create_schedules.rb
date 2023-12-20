# frozen_string_literal: true

# Create Schedules table
class CreateSchedules < ActiveRecord::Migration[7.0]
  def change
    create_table :schedules do |t|
      t.string :day
      t.string :opening_time
      t.string :closing_time
      t.references :shop, null: false, foreign_key: true

      t.timestamps
    end
  end
end
