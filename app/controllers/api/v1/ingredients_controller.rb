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

      def update
        daily_log = current_user.daily_logs.find_by(id: params[:daily_log_id])
        return render json: {error: 'Daily log not found'}, status: :not_found unless daily_log

        meal = daily_log.meals.find_by(id: params[:meal_id])
        return render json: {error: 'Meal not Found in this daily log'}, status: :not_found unless meal

        ingredient = Ingredient.find_by(id: params[:id])
        return render json: {error: 'Ingredient not found'}, status: :not_found unless ingredient

        if ingredient.update(ingredient_params)
          render json: ingredient, status: :ok
        else
          render json: { errors: ingredient.errors.full_messages}, status: :unprocessable_entity
        end
      end

      def destroy
        daily_log = current_user.daily_logs.find_by(id: params[:daily_log_id])
        return render json: {error: 'Daily log not found'}, status: :not_found unless daily_log

        meal = daily_log.meals.find_by(id: params[:meal_id])
        return render json: {error: 'Meal not Found in this daily log'}, status: :not_found unless meal
        
        ingredient = Ingredient.find_by(id: params[:id])
        return render json: { error: 'Ingredient not found'}, status: :not_found unless ingredient

        ingredient.destroy
        render json: {message: 'ingredient deleted successfully'}, status: :ok
      end

      private

      def ingredient_params
        params.require(:ingredient).permit(:name, :quantity, :calories, :protein, :carbs, :fat)
      end
    end
  end
end