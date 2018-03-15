class RemoveUserLocation < ActiveRecord::Migration[5.1]
  def change
    remove_column :raw_tweets, :user_location
  end
end
