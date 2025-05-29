
# 🥗 Calories Tracker Backend API

This is the **backend API** for the **Calories Tracker** application, built with **Ruby on Rails**. It provides endpoints for tracking meals, nutritional intake, weight progression, and calorie goals over time.

---

## 🛠️ Getting Started

### 📦 Requirements

- Ruby 3.2+
- Rails 7+
- PostgreSQL
- [JWT](https://github.com/jwt/ruby-jwt) gem for authentication
- CORS configured for frontend (React) integration


---

### ⚙️ Setup

1. **Clone the repository**  
   ```bash
   git clone https://github.com/your-username/calories-tracker-backend.git
   cd calories-tracker-backend
   ```

2. **Install dependencies**  
   ```bash
   bundle install
   ```

3. **Create & migrate the database**  
   ```bash
   rails db:create
   rails db:migrate
   ```

4. **(Optional) Seed the database**  
   ```bash
   rails db:seed
   ```

5. **Run the server**  
   ```bash
   rails s
   ```


## 🚀 Features

- 🔐 **User Authentication** (Token-based using JWT)
- 📆 **Daily Logs**: Log meals and ingredients per day
- 🍽️ **Meals & Ingredients**: Each meal has multiple ingredients with full nutritional data
- 📊 **Nutrition Calculations**: Automatically aggregates daily totals (calories, protein, carbs, fat)
- 🔻 **Calorie Deficit**: Computes calorie deficit based on user goals
- 📈 **Stats Endpoints**:
  - 🗓️ Weekly
  - 📅 Monthly
  - 🗓️ Annually
- ⚖️ **Weight Tracking**: Record and fetch body weight over time
- 🧾 **JSON API**: Cleanly formatted for React frontend consumption

---

## 🔗 API Endpoints

### 🔑 Authentication
- `POST /api/v1/login` — Login and receive a token
- `POST /api/v1/signup` — Register a new user

### 📅 Daily Logs
- `GET /api/v1/daily_logs` — Get all logs for the current user
- `GET /api/v1/daily_logs/:id` — Get a specific log
- `POST /api/v1/daily_logs` — Create or fetch a log for a specific date

### 🍽️ Meals & Ingredients
- `POST /api/v1/meals` — Add a new meal to a daily log
- `POST /api/v1/ingredients` — Add ingredients to a meal

### 📊 Statistics
- `GET /api/v1/stats/weekly`
- `GET /api/v1/stats/monthly`
- `GET /api/v1/stats/annually`

Each stat returns:
- 🔥 Total Calories
- ⚖️ Average Calories
- 📍 Latest Weight
- 🕒 Date Range

---

## 🧬 Model Structure

### 👤 User
- `daily_calories_goal`
- `has_many :daily_logs`
- `has_many :weight_entries`

### 📅 DailyLog
- `belongs_to :user`
- `has_many :meals`
- `daily_total_nutrition`: returns total for calories, protein, carbs, fat
- `daily_calorie_deficit`: based on user's goal

### 🍲 Meal
- `belongs_to :daily_log`
- `has_many :ingredients`
- `total_nutrition`: sums nutritional values from ingredients

### 🥑 Ingredient
- `name`, `calories`, `protein`, `carbs`, `fat`

### ⚖️ WeightEntry
- `weight`, `date` per user

-----
## 🗄️ Database Configuration

This application uses PostgreSQL as the database engine for all environments (development, test, and production). Here's how the setup is handled:

- Adapter: PostgreSQL (pg gem)
- Encoding: Unicode
- Connection pooling: Controlled via RAILS_MAX_THREADS (defaults to 5)
- Authentication:
- - Username: postgres (or your configured user)
- - Password: 12345 (or from environment variables)
- - Host: localhost

Environment-specific databases:

- development: calories_tracker_b_development

- test: calories_tracker_b_test

- production: Uses ENV['DATABASE_URL'] for safety and flexibility in deployment


----

## 📬 Contact

Created by **Facundo Robert** – [GitHub](https://github.com/RobertFacundo)  
Feel free to reach out for collaboration or feedback!

## 📄 License

This project is licensed under the [MIT License](LICENSE).
----

