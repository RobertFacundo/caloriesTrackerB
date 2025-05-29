class Api::V1::DailyLogsController < ApplicationController
  before_action :authorize

  def index
    logs = current_user.daily_logs.includes(meals: :ingredients).order(date: :desc)
    render json: logs.as_json(
      include: { 
        meals: { 
          include: :ingredients,
          methods: :total_nutrition
        }
      },
      methods: [:daily_total_nutrition, :daily_calorie_deficit]
    )
  end

  def show
    log = current_user.daily_logs.includes(meals: :ingredients).find(params[:id])
    render json: log.as_json(
      include: { 
        meals: { 
          include: :ingredients,
          methods: :total_nutrition
        }
      },
      methods: [:daily_total_nutrition, :daily_calorie_deficit]
    )
  end

  def create
    log = current_user.daily_logs.find_or_initialize_by(date: params[:date])
    if log.save
      render json: log, status: :created
    else
      render json: { errors: log.errors.full_messages}, status: :unprocessable_entity
    end
  end
end
