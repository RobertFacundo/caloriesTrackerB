class Api::V1::StatsController < ApplicationController
  before_action :authorize

  def weekly
    render json: stats_for_range(Date.today.beginning_of_week, Date.today.end_of_week)
  end

  def monthly
    render json: stats_for_range(Date.today.beginning_of_month, Date.today.end_of_month)
  end

  def annually
    render json: stats_for_range(Date.today.beginning_of_year, Date.today.end_of_year)
  end

  private

  def stats_for_range(start_date, end_date)
    logs = current_user.daily_logs
                       .where(date: start_date..end_date)
                       .includes(:meals)
    total_calories =logs.sum { |log| log.daily_total_nutrition[:calories].to_f}
    average_calories = logs.any? ? total_calories / logs.size.to_f : 0

    weight_entry = current_user.weight_entries
                               .where(date: start_date..end_date)
                               .order(:date)
                               .last
    {
      range: "#{start_date} to #{end_date}",
      total_calories: total_calories.round,
      average_calories: average_calories.round,
      weight: weight_entry&.weight,
      weight_date: weight_entry&.date 
    }
  end
end
