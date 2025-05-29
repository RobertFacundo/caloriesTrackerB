class WeightEntry < ApplicationRecord
  belongs_to :user
  validates :weight, presence: true
  validates :date, presence: true
end
