# frozen_string_literal: true

# Serializer for formating shop data.
class ShopSerializer < ActiveModel::Serializer
  attributes :id, :name, :sorted_schedules

  def sorted_schedules
    object.sorted_schedules.map do |schedule|
      {
        id: schedule.id,
        day: translate_day(schedule.day),
        opening_time: schedule.opening_time,
        closing_time: schedule.closing_time
      }
    end
  end

  def translate_day(day)
    day_key = "date.day_names.#{day.downcase}"
    I18n.t(day_key)
  end
end
