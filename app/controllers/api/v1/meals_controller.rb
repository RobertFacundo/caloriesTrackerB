module Api
  module V1
    class MealsController < ApplicationController
        
      def create
        daily_log = DailyLog.find(params[:daily_log_id])

        meal = daily_log.meals.new(meal_params)

        if meal.save
          render json: meal, status: :created
        else
          render json: { errors: meal.errors.full_messages}, status: :unprocessable_entity
        end
      end

      def destroy
        daily_log = DailyLog.find(params[:daily_log_id])
        meal = daily_log.meals.find(params[:id])

        if meal.destroy
          head :no_content
        else
          render json: { errors: meal.errors.full_messages}, status: :unprocessable_entity
        end
      end

      private

      def meal_params
        params.require(:meal).permit(:name, :calories, :protein, :carbs, :fat)
      end
    end
  end
end
