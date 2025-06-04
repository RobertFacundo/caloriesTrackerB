class AddTrainingDayAndCaloriesGoalToDailyLogs < ActiveRecord::Migration[8.0]
  def change
    add_column :daily_logs, :training_day, :boolean
    add_column :daily_logs, :daily_calories_goal, :integer
  end
end
