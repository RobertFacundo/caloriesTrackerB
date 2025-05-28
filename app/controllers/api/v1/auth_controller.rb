class Api::V1::AuthController < ApplicationController
    def login
      user = User.find_by(username: params[:username])
      if user&.authenticate(params[:password])
        token = encode_token({user_id: user.id})
        render json: {user: user, token: token}, status: :ok
      else
        render json: { error: 'Invalid email or password' }, status: :unauthorized
      end
    end
end
