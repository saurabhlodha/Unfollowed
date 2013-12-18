class ChangeTextFormatInMyTable < ActiveRecord::Migration
  def change
  	change_column :followers, :follower_id, :text
  	change_column :followers, :follower_name, :text
  	
  end
end
