class DailyLog < ApplicationRecord
  belongs_to :user
  has_many :meals, dependent: :destroy

  def daily_total_nutrition
    totals = { calories: 0, protein: 0, carbs: 0, fat: 0}

    meals.includes(:ingredients).each do |meal|
      nutrition = meal.total_nutrition
      totals[:calories] += nutrition[:calories]
      totals[:protein] += nutrition[:protein]
      totals[:carbs] += nutrition[:carbs]
      totals[:fat] += nutrition[:fat]
    end

    totals
  end

  def daily_calorie_deficit
    return nil unless user.daily_calories_goal && daily_total_nutrition[:calories]

    user.daily_calories_goal - daily_total_nutrition[:calories]
  end
end
