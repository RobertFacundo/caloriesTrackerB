class AddDailyCaloriesGoalToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :daily_calories_goal, :integer
  end
end
