class CreateBubbles < ActiveRecord::Migration
  def self.up
    create_table :bubbles do |t|
      t.string   :title
      t.string   :body
      t.datetime :expire_at
      t.integer  :user_id
      t.boolean  :solved

      t.timestamps
    end
  end

  def self.down
    drop_table :bubbles
  end
end
