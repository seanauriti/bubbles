class AddAimNotifierPreference < ActiveRecord::Migration
  def self.up
    add_column :users, :wants_aim_notifications, :boolean
  end

  def self.down
    remove_column :users, :wants_aim_notifications
  end
end
