class CreateWeightEntries < ActiveRecord::Migration[8.0]
  def change
    create_table :weight_entries do |t|
      t.references :user, null: false, foreign_key: true
      t.float :weight
      t.date :date

      t.timestamps
    end
  end
end
