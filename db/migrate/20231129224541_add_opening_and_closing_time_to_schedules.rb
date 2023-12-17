# frozen_string_literal: true

class AddOpeningAndClosingTimeToSchedules < ActiveRecord::Migration[7.0]
  def change
    add_column :schedules, :opening_time, :time
    add_column :schedules, :closing_time, :time
  end
end
