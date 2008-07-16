class AddAimToUsers < ActiveRecord::Migration
  def self.up
    add_column "users", "aim", :string
  end

  def self.down
    remove_column "users", "aim", :string
  end
end
