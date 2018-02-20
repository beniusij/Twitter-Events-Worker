class MakeTweetIdBigint < ActiveRecord::Migration[5.1]
  def change
    change_column :raw_tweets, :tweet_id, 'bigint USING tweet_id::bigint', unique: true
  end
end
