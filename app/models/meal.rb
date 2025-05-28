class Meal < ApplicationRecord
  belongs_to :daily_log
  has_many :ingredients, dependent: :destroy
end
