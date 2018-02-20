class ChangeTweetIdType < ActiveRecord::Migration[5.1]
  def change
    change_column :raw_tweets, :tweet_id, :string
  end
end
