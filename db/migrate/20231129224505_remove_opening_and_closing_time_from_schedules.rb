# frozen_string_literal: true

# Remove opening and closing time from Schedules
class RemoveOpeningAndClosingTimeFromSchedules < ActiveRecord::Migration[7.0]
  def change
    remove_column :schedules, :opening_time, :string
    remove_column :schedules, :closing_time, :string
  end
end
