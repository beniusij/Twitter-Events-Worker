class AddTweetIdToEvent < ActiveRecord::Migration[5.1]
  def change
    add_column :events, :tweet_id, :bigint
  end
end
