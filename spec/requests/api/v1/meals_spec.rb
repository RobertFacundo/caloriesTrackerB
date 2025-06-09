require 'swagger_helper'

RSpec.describe 'API::V1::Meals', type: :request do
  let(:user) { User.create(username: 'facu', password: '123456a') }
  let(:token) { token_for(user) }
  let(:daily_log){ DailyLog.create(user: user, date: Date.today) }

  path '/api/v1/daily_logs/{daily_log_id}/meals' do
    post 'Create a new meal for a dialy log' do
      tags 'Meals'
      consumes 'application/json'
      produces 'application/json'
      security [ bearer_auth: [] ]

      parameter name: :daily_log_id, in: :path, type: :string
      parameter name: :meal, in: :body, schema: {
        type: :object,
        properties: {
          meal: {
            type: :object,
            properties: {
              name: { type: :string },
            },
            required: ['name']
          }
        },
        required: ['meal']
      }

      response '201', 'Meal created' do
        let(:'Authorization') { "Bearer #{token}" }
        let(:daily_log_id) { daily_log.id }
        let(:meal) do
          {
            meal: {
              name: 'Lunch'   
            }
          }
        end
        run_test!
      end

      response '422', 'Invalid meal data' do
        let(:'Authorization'){ "Bearer #{token}" }
        let(:daily_log_id) { daily_log.id}
        let(:meal) { {meal: { name: ''}}}
        run_test!
      end
    end
  end

  path '/api/v1/daily_logs/{daily_log_id}/meals/{id}' do
    delete 'Delete a meal from a daily log' do
      tags 'Meals'
      produces 'application/json'
      security [ bearer_auth: [] ]

      parameter name: :daily_log_id, in: :path, type: :string
      parameter name: :id, in: :path, type: :string

      response '204', 'Meal Calories' do
        let(:'Authorization') { "Bearer #{token}" }
        let(:daily_log_id) { daily_log.id }
        let(:id) do
          daily_log.meals.create!(name: 'Breakfast').id
        end
      run_test!
      end

      response '404', 'Meal not found' do
        let(:'Authorization') { "Bearer #{token}" }
        let(:daily_log_id) { daily_log.id}
        let(:id) { 'invalid' }
        run_test!
      end
    end
  end 
end