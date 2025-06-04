class DailyLog < ApplicationRecord
  belongs_to :user
  has_many :meals, dependent: :destroy

  before_create :set_default_calories_goal

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
    return nil unless daily_calories_goal && daily_total_nutrition[:calories]

    daily_calories_goal - daily_total_nutrition[:calories]
  end

  private

  def set_default_calories_goal
    return unless user && user.respond_to?(:calculate_daily_calories_goal)

    base_goal = user.calculate_daily_calories_goal
    if base_goal
      self.daily_calories_goal = training_day ? (base_goal * 1.1).to_i : base_goal;
    end
  end
end
