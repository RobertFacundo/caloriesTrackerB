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
          if current_user.update(details_params.merge(onboarding_completed: true))

            calories_goal = current_user.calculate_daily_calories_goal
            if calories_goal && current_user.daily_calories_goal != calories_goal
              current_user.update_column(:daily_calories_goal, calories_goal) 
            end

            if params[:user][:weight].present?
              new_weight = params[:user][:weight].to_f
              last_entry = current_user.weight_entries.order(date: :desc).find_by(date: Date.today)

              if last_entry.nil? || last_entry.weight != new_weight
                current_user.weight_entries.create!(
                  weight: new_weight,
                  date: Date.today
                )
              end
            end

            if (log = current_user.daily_logs.find_by(date: Date.today))
              base_goal = current_user.daily_calories_goal
              log.daily_calories_goal = log.training_day? ? (base_goal * 1.1).to_i : base_goal
              log.save!
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
        params.require(:user).permit(:weight, :height, :age, :gender, :activity_level, :onboarding_completed)
      end
  end
