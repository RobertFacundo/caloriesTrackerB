class Api::V1::UsersController < ApplicationController
    def create
      user = User.new(user_params)
      if user.save
        token = encode_token({user_id: user.id})
        render json: { user: user, token: token }, status: :created
      else
        render json: { errors: user.errors.full_messages}, status: :unprocessable_entity
      end
    end 

    def me
      return unless authorize
      render json: current_user
    end

    def update_details
      return unless authorize
      ActiveRecord::Base.transaction do
        if current_user.update(details_params)

          calories_goal = current_user.calculate_daily_calories_goal
          
          if calories_goal && current_user.daily_calories_goal != calories_goal
            current_user.update_column(:daily_calories_goal, calories_goal) 
          end

          if current_user.weight_entries.empty? && params[:user][:weight].present?
            current_user.weight_entries.create!(
              weight: params[:user][:weight],
              date: Date.today
            )
          end  

          render json: current_user
        else
          render json: { errors: current_user.errors.full_messages}, status: :unprocessable_entity
        end
      end
    end   

    private

    def user_params
      params.require(:user).permit(:username, :password)
    end

    def details_params
      params.require(:user).permit(:weight, :height, :age, :gender, :activity_level)
    end
end
