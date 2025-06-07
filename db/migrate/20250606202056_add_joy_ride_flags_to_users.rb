class AddJoyRideFlagsToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :has_seen_home_joyride, :boolean
    add_column :users, :has_seen_profile_joyride, :boolean
  end
end
