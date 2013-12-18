class CreateFollowers < ActiveRecord::Migration
  def change
    create_table :followers do |t|
      t.string :uid
      t.string :follower_id
      t.string :follower_name
      t.timestamps
    end
  end
end
