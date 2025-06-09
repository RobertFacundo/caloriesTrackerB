require 'swagger_helper'

RSpec.describe 'API::V1::DailyLogs', type: :request do
  let(:user) { User.create(username: 'facu', password: '123456a') }
  let(:token) { token_for(user) }

  path '/api/v1/daily_logs' do
    get 'Get all dailylogs for the current user' do
      tags 'DailyLogs'
      produces 'application/json'
      security [bearer_auth: [] ]

      response '200', 'List of daily logs' do
        let(:'Authorization') { "Bearer #{token}"}
        run_test!
      end

      response '401', 'Unauthorized' do
        let(:'Authorization') { '' }
        run_test!
      end
    end

    post 'Create or find daily log for a specific date' do
      tags 'DailyLogs'
      consumes 'application/json'
      produces 'application/json'
      security [ bearer_auth: [] ]

      parameter name: :log, in: :body, schema: {
        type: :object,
        properties: {
          date: { type: :string, format: :date }
        },
        required: ['date']
      }

      response '201', 'Daily log created or found' do
        let(:'Authorization') { 'Bearer #{token}' }
        let(:log) { { date: Date.today.to_s} }
        run_test!
      end

      response '422', 'Invalid data' do
        let(:'Authorization') { 'Bearer #{token}' }
        let(:log) { { date: ''} }
        run_test!
      end
    end
  end
  
  path '/api/v1/daily_logs/{id}' do
    get 'Show a specific daily log' do
      tags 'DailyLogs'
      produces 'application/json'
      security [ bearer_auth: []]
      parameter name: :id, in: :path, type: :string

      response '200', 'Daily log shown' do
        let(:'Authorization') { "Bearer #{token}" }
        let(:id) { user.daily_logs.create!(date: Date.today).id }
        run_test!
      end

      response '404', 'Not found' do
        let(:'Authorization') { "Bearer #{token}" }
        let(:id) { "invalid" }  
        run_test!
      end
    end
  end
end
