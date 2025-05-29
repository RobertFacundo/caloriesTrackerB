# Calories Tracker Backend API

This is the backend API for the Calories Tracker application, built using Ruby on Rails. It provides endpoints for users to track their daily meals, nutritional intake, and weight progression over time.

## Features

- **User Authentication** (Token-based)
- **Daily Logs**: Track daily meals and ingredients.
- **Meals and Ingredients**: Each meal consists of multiple ingredients with detailed nutritional data.
- **Nutrition Calculations**: Aggregates total daily calories, protein, carbs, and fat.
- **Calorie Deficit**: Calculates daily calorie deficit based on the user's calorie goal.
- **Stats Endpoints**:
  - Weekly
  - Monthly
  - Annually
- **Weight Tracking**: Store and retrieve weight entries.
- **JSON API responses** formatted for easy frontend integration.

## API Endpoints

### Authentication
- `POST /api/v1/login` — Login and receive a token
- `POST /api/v1/signup` — Create a new user

### Daily Logs
- `GET /api/v1/daily_logs` — Fetch all daily logs for the user
- `GET /api/v1/daily_logs/:id` — Fetch a specific daily log
- `POST /api/v1/daily_logs` — Create or fetch a log for a specific date

### Meals and Ingredients
- `POST /api/v1/meals` — Add a new meal to a daily log
- `POST /api/v1/ingredients` — Add ingredients to a meal

### Stats
- `GET /api/v1/stats/weekly`
- `GET /api/v1/stats/monthly`
- `GET /api/v1/stats/annually`

Each stat returns:
- Total calories
- Average calories
- Weight (latest entry)
- Date range

## Model Structure

- **User**
  - `daily_calories_goal`
  - `has_many :daily_logs`
  - `has_many :weight_entries`

- **DailyLog**
  - `belongs_to :user`
  - `has_many :meals`
  - `daily_total_nutrition` method for calorie/protein/carb/fat total
  - `daily_calorie_deficit` based on goal

- **Meal**
  - `belongs_to :daily_log`
  - `has_many :ingredients`
  - `total_nutrition` method aggregates ingredients

- **Ingredient**
  - Includes `name`, `calories`, `protein`, `carbs`, `fat`

- **WeightEntry**
  - Stores `weight` and `date` per user

## Requirements

- Ruby on Rails 7+
- PostgreSQL
- JWT gem for auth
- CORS configured for frontend access

## Next Steps

Frontend implementation using React will consume the API endpoints listed above. Logic for color indicators (calorie surplus/deficit) and charts will be handled via the frontend.

---

> This API is designed for personal or portfolio use as part of a full-stack fitness/nutrition tracking application.