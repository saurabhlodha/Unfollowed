class AddProviderToFollower < ActiveRecord::Migration
  def change
    add_column :followers, :provider, :string
  end
end
