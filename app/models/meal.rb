class Meal < ApplicationRecord
  belongs_to :daily_log
  has_many :ingredients, dependent: :destroy

  def total_nutrition
    {
      calories: ingredients.sum(:calories),
      protein: ingredients.sum(:protein),
      carbs: ingredients.sum(:carbs),
      fat: ingredients.sum(:fat)
    }
  end
end
