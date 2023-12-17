# frozen_string_literal: true

# Serializer for formating schedule data.
class ScheduleSerializer < ActiveModel::Serializer
  attributes :id, :day, :opening_time, :closing_time

  def day
    translate_day(object.day)
  end

  def translate_day(day)
    I18n.t("date.day_names.#{day.downcase}")
  end
end
