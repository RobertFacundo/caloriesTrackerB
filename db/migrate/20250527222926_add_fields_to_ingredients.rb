class AddFieldsToIngredients < ActiveRecord::Migration[8.0]
  def change
    add_column :ingredients, :carbs, :integer
    add_column :ingredients, :fat, :integer
  end
end
