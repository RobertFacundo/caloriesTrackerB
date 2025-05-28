class DailyLog < ApplicationRecord
  belongs_to :user
  has_many :meals, dependent: :destroy
end
