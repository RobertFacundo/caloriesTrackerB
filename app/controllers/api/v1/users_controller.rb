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
      if current_user.update(details_params)
        render json: current_user
      else
        render json: { errors: current_user.errors.full_messages}, status: :unprocessable_entity
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
