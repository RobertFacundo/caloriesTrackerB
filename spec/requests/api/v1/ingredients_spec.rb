require 'swagger_helper'

RSpec.describe 'API::V1::Ingredients', type: :request do
  let(:user) { User.create(username: 'facu', password: '123456a') }
  let(:token) { token_for(user)}
  let(:daily_log) { DailyLog.create(user: user, date: Date.today) }
  let(:meal) { daily_log.meals.create(name: 'Lunch', calories: 0, protein: 0, carbs: 0, fat: 0) }

  path '/api/v1/daily_logs/{daily_log_id}/meals/{meal_id}/ingredients' do
    post 'Create an ingredient' do
      tags 'Ingredients'
      consumes 'application/json'
      produces 'application/json'
      security [ bearer_auth: [] ]

      parameter name: :daily_log_id, in: :path, type: :string
      parameter name: :meal_id, in: :path, type: :string
      parameter name: :ingredient, in: :body, schema: {
        type: :object,
        properties: {
          ingredient: {
            type: :object,
            properties: {
              name: {type: :string },
              calories: { type: :number },
              protein: { type: :number },
              carbs: { type: :number },
              fat: { type: :number } 
            },
            required: ['name', 'calories', 'protein', 'fat']
          }
        },
        required: ['ingredient']
      }

      response '201', 'Ingredient created' do
        let(:'Authorization') { "Bearer #{token}" }
        let(:daily_log_id) { daily_log.id}
        let(:meal_id) { meal.id }
        let(:ingredient) do
          {
            ingredient: {
              name: 'Chicken',
              calories: 500,
              protein: 20,
              carbs: 10,
              fat: 3
            }
          }
        end
        run_test!
      end

      response '422', 'Invalid data' do
        let(:'Authorization') { "Bearer #{token}" }
        let(:daily_log_id) { daily_log.id }
        let(:meal_id) { meal.id }
        let(:ingredient) { { ingredient: { name: '' } } }
        run_test!
      end
    end
  end

  path '/api/v1/daily_logs/{daily_log_id}/meals/{meal_id}/ingredients/{id}' do
    delete 'Delete an ingredient' do
      tags 'Ingredients'
      produces 'application/json'
      security [ bearer_auth: [] ]

      parameter name: :daily_log_id, in: :path, type: :string
      parameter name: :meal_id, in: :path, type: :string
      parameter name: :id, in: :path, type: :string

      response '200', 'Ingredient deleted' do
        let(:'Authorization') { "Bearer #{token}" }
        let(:daily_log_id) { daily_log.id }
        let(:meal_id) { meal.id }
        let(:id) { meal.ingredients.create(name: 'Tomate', calories: 10, protein: 1, carbs: 2, fat: 0).id }
        run_test!
      end

      response '404', 'Ingredient not found' do
        let(:'Authorization') { "Bearer #{token}" }
        let(:daily_log_id) { daily_log.id }
        let(:meal_id) { meal.id }
        let(:id) { 'invalid' }
        run_test!
      end
    end
  end
end
