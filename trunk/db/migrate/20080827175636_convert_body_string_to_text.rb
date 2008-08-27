class ConvertBodyStringToText < ActiveRecord::Migration
  def self.up
    change_column :bubbles, :body, :text
  end

  def self.down
    change_column :bubbles, :body, :string
  end
end
