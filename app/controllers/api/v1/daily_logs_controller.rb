class Api::V1::DailyLogsController < ApplicationController
  before_action :authorize

  def index
    logs = current_user.daily_logs.includes(meals: :ingredients).order(date: :desc)
    weights_by_date = current_user.weight_entries.group_by(&:date)

    enriched_logs = logs.map do |log|
      log.as_json(
        include: { 
          meals: { 
            include: :ingredients,
            methods: :total_nutrition
          }
        },
        methods: [:daily_total_nutrition, :daily_calorie_deficit]
      ).merge(
        weight: weights_by_date[log.date]&.first&.weight
      )
    end

    render json: enriched_logs
  end

  def today
    log = current_user.daily_logs.includes(meals: :ingredients).find_by(date: Date.today)
    weight = current_user.weight_entries.find_by(date: Date.today)&.weight

    if log
      render json: log.as_json(
        include: {
          meals: {
            include: :ingredients,
            methods: :total_nutrition
          }
        },
        methods: [:daily_total_nutrition, :daily_calorie_deficit]
      ).merge(weight: weight)
    else
      render json: {error: "No daily log found"}, status: :not_found
    end
  end

  def show
    log = current_user.daily_logs.includes(meals: :ingredients).find(params[:id])
    weight = current_user.weight_entries.find_by(date: log.date)&.weight

    
    render json: log.as_json(
      include: { 
        meals: { 
          include: :ingredients,
          methods: :total_nutrition
        }
      },
      methods: [:daily_total_nutrition, :daily_calorie_deficit]
    ).merge(weight: weight)
  end

  def create
    log = current_user.daily_logs.find_or_initialize_by(date: params[:date])
    if log.save
      render json: log, status: :created
    else
      render json: { errors: log.errors.full_messages}, status: :unprocessable_entity
    end
  end

  def update_training_day
    log = current_user.daily_logs.find_by(date: params[:date])
    return render json: {error: "Log not found"}, status: :not_found unless log

    log.training_day = params[:training_day]
    base_goal = current_user.calculate_daily_calories_goal
    log.daily_calories_goal = log.training_day? ? (base_goal * 1.1).to_i : base_goal

    if log.save
      render json: log.as_json(
        include:{
          meals:{
            include: :ingredients,
            methods: :total_nutrition
          }
        },
        methods: [:daily_total_nutrition, :daily_calorie_deficit]
      )
    else
      render json: {errors: log.errors.full_messages}, status: :unprocessable_entity
    end
  end
end
