class Api::V1::StatsController < ApplicationController
  before_action :authorize

  def weekly
    render json: logs_with_nutrition_for_range(Date.today.beginning_of_week, Date.today.end_of_week)
  end

  def monthly
    render json: logs_with_nutrition_for_range(Date.today.beginning_of_month, Date.today.end_of_month)
  end

  def annually
    render json: logs_with_nutrition_for_range(Date.today.beginning_of_year, Date.today.end_of_year)
  end

  private

  def logs_with_nutrition_for_range(start_date, end_date)
    logs = current_user.daily_logs
                       .where(date: start_date..end_date)
                       .includes(:meals)

    weights_by_date = current_user.weight_entries
                                  .order(:date, :created_at)
                                  .group_by(&:date)
                                  .transform_values { |entries| entries.last}
    
    sorted_weights = current_user.weight_entries.order(:date, :created_at)
    
    logs_data = logs.map do |log|
      weight = weights_by_date[log.date]&.weight

      if weight.nil?
        previous_weight = sorted_weights
                            .select{ |entry| entry.date < log.date}
                            .last
        weight = previous_weight&.weight
      end

      {
        id: log.id,
        date: log.date,
        calories: log.daily_total_nutrition[:calories],
        protein: log.daily_total_nutrition[:protein],
        carbs: log.daily_total_nutrition[:carbs],
        fat: log.daily_total_nutrition[:fat],
        deficit: log.daily_calorie_deficit,
        training_day: log.training_day,
        goal: log.daily_calories_goal,
        weight: weight
      }
    end
    {
      range: "#{start_date} to #{end_date}",
      total_days: logs.size,
      logs: logs_data
    }
  end
end
