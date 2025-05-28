module Api
  module V1
    class IngredientsController < ApplicationController

      def create
        daily_log = DailyLog.find_by(id: params[:daily_log_id])
        return render json: { error: 'Daily log not found' }, status: :not_found unless daily_log

        meal = daily_log.meals.find_by(id: params[:meal_id]) 
        return render json: { error: 'Meal not found in this daily log' }, status: :not_found unless meal

        ingredient = meal.ingredients.new(ingredient_params)    

        if ingredient.save
          render json: ingredient, status: :created
        else
          render json: {errors: ingredient.errors.full_messages}, status: :unprocessable_entity
        end
      end

      private

      def ingredient_params
        params.require(:ingredient).permit(:name, :quantity, :calories, :protein, :carbs, :fat)
      end
    end
  end
end