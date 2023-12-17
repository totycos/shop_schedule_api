# frozen_string_literal: true

# Module to sort days starting with the current day
module SortByCurrentDay
  extend ActiveSupport::Concern

  def sorted_schedules
    self.class.sorted_schedules(schedules)
  end

  # Sort days starting by today's day
  class_methods do
    def sorted_schedules(schedules)
      current_day = Time.now.strftime('%A').downcase # downcase to match with enum days
      day_names = Schedule.days.keys.map(&:to_s)
      sorted_days = day_names.rotate(day_names.index(current_day))
      schedules.sort_by do |schedule|
        [sorted_days.index(schedule.day), schedule.opening_time] # sort by day then by opening_time
      end
    end
  end
end
