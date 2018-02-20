class IndexTweetId < ActiveRecord::Migration[5.1]
  def change
    add_index :raw_tweets, :tweet_id, unique: true
  end
end
