class CreateAuthentications < ActiveRecord::Migration
  def self.up
    create_table :authentications do |t|
      t.integer :user_id
      t.string :provider
      t.string :uid
      t.string :user_name
      t.string :oauth_token
      t.string :oauth_secret
      t.string :email
      t.timestamps
    end
  end

  def self.down
    drop_table :authentications
  end
end
