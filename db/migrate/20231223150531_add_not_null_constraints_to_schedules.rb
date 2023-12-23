class AddNotNullConstraintsToSchedules < ActiveRecord::Migration[7.0]
  def change
    change_column :schedules, :day, :string, null: false
    change_column :schedules, :opening_time, :datetime, null: false
    change_column :schedules, :closing_time, :datetime, null: false
  end
end
