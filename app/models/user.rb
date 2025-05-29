class User < ApplicationRecord
  has_secure_password
  has_many :daily_logs, dependent: :destroy
  has_many :weight_entries, dependent: :destroy 

  validates :username, presence: true, uniqueness: true

  def bmr
    return nil unless weight && height && age && gender

    if gender === 'male'
      88.362 + (13.397 * weight) + (4.799 * height) - (5.677 * age)
    else
      447.593 + (9.247 * weight) + (3.098 * height) - (4.330 * age)
    end
  end

  def activity_multiplier
    case activity_level
    when 'sedentary'
      1.2
    when 'light'
      1.375
    when 'moderate'
      1.55
    when 'active'
      1.725
    when 'very_active'
      1.9
    else
      1.2
    end
  end
  
  def calculate_daily_calories_goal
    return nil unless bmr
    (bmr * activity_multiplier).round
  end
end
