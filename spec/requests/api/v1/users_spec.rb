require 'swagger_helper'

RSpec.describe 'API::V1::Users', type: :request do

    path '/api/v1/signup' do
      post 'Create a new user' do
        tags 'Users'
        consumes 'application/json'
        produces 'application/json'
        parameter name: :user, in: :body, schema: {
          type: :object,
          properties: {
            user: {          
              type: :object,
              properties: {
                username: { type: :string, example: 'string' },
                password: { type: :string, example: '123456a' }
              },
              required: ['username', 'password']
            }
          },    
          required: [ 'user' ]
        }

        response '201', 'User created' do
          let(:user) { { username: 'facu', password: '123456a' } }
          run_test!
        end

        response '422', 'Invalid data' do
          let(:user) { { username: '', password: '' } }
          run_test!
        end
      end
    end

    path '/api/v1/me' do
      get 'get authenticated user' do
        tags 'Users'
        produces 'application/json'
        security [ bearer_auth: [] ]

        response '200', 'Authenticated user' do
          let(:'Authorization') { "Bearer #{token_for(User.create(username: 'facu', password: '123456a'))}"}
          run_test!
        end

        response '401', 'Not authorized' do
          let(:'Authorization') { '' }
          run_test!
        end
      end
    end
end