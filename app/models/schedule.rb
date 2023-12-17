# frozen_string_literal: true

class Schedule < ApplicationRecord
  include SortByCurrentDay
  DEFAULT_DATE = Date.new(2000, 1, 1)
  before_validation :format_opening_time, :format_closing_time
  belongs_to :shop

  enum day: { monday: 'Monday', tuesday: 'Tuesday', wednesday: 'Wednesday', thursday: 'Thursday', friday: 'Friday',
              saturday: 'Saturday', sunday: 'Sunday' }

  validates :day, presence: true, inclusion: { in: days.keys }
  validates :opening_time, presence: true, timeliness: { type: :time, before: '2000-01-01 23:59:59' }
  validates :closing_time, presence: true, timeliness: { type: :time, before: '2000-01-01 23:59:59' }
  validates :shop_id, presence: true

  # validate :valid_opening_time_format, :valid_closing_time_format
  validate :opening_time_before_closing_time
  validate :no_overlapping_schedules
  validate :shop_exists

  private

  def format_opening_time
    format_time_attribute(:opening_time)
  end

  def format_closing_time
    format_time_attribute(:closing_time)
  end

  def format_time_attribute(attribute)
    attribute_value = send(attribute)
    self[attribute] = Time.zone.parse("#{DEFAULT_DATE} #{attribute_value}") if attribute_value.present?
  rescue ArgumentError
    errors.add(attribute, 'format not valid')
  end

  def opening_time_before_closing_time
    return unless opening_time.present? && closing_time.present? && opening_time >= closing_time

    errors.add(:closing_time, 'must be greater than opening time')
  end

  def no_overlapping_schedules
    return unless shop_id.present? && day.present? && opening_time.present? && closing_time.present?

    existing_schedules = Schedule.where(shop_id: shop_id, day: day).where.not(id: id)

    if existing_schedules.any? do |schedule|
         overlap?(opening_time, closing_time, schedule.opening_time, schedule.closing_time)
       end
      errors.add(:opening_time, 'overlaps with an existing schedule')
      errors.add(:closing_time, 'overlaps with an existing schedule')
    end
  end

  def overlap?(start_time1, end_time1, start_time2, end_time2)
    range1 = (start_time1.to_i...end_time1.to_i)
    range2 = (start_time2.to_i...end_time2.to_i)

    range1.overlaps?(range2)
  end

  def shop_exists
    Shop.exists?(shop_id) ? true : errors.add(:shop_id, 'Must belong to an existing shop')
  end
end
