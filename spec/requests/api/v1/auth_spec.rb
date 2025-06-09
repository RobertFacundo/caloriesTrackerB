require 'swagger_helper'

RSpec.describe 'API::V1::Auth', type: :request do
  path '/api/v1/login' do
    post 'Authenticate user and return token' do
      tags 'Authentication'
      consumes 'application/json'
      produces 'application/json'

      parameter name: :credentials, in: :body, schema: {
        type: :object,
        properties: {
          username: { type: :string },
          password: { type: :string }
        },
        required: ['username', 'password']
      }

      response '200', 'User authenticated' do
        let(:user) { User.create(username: 'facu', password: '123456a') }
        let(:credentials) { { username: user.username, password: ' 123456a'} }
        run_test!
      end

      response '401', 'Invalid credentials' do
        let(:credentials) { { username: 'facu', password: 'wrongpass'}}
        run_test!
      end
    end
  end
end