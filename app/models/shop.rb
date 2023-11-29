# frozen_string_literal: true

# Model representing a shop in the application.
class Shop < ApplicationRecord
  has_many :schedules, dependent: :destroy

  validates :name, presence: true, uniqueness: { case_sensitive: false }
end
