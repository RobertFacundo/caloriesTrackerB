class CreateDailyLogs < ActiveRecord::Migration[8.0]
  def change
    create_table :daily_logs do |t|
      t.date :date
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
