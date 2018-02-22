class AddTimeAndUserLocation < ActiveRecord::Migration[5.1]
  def change
    add_column :raw_tweets, :tweet_posted_at, :timestamp
    add_column :raw_tweets, :user_location, :string
  end
end
