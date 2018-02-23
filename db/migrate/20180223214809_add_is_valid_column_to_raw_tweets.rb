class AddIsValidColumnToRawTweets < ActiveRecord::Migration[5.1]
  def change
    add_column :raw_tweets, :is_valid, :boolean, null: false, default: false
  end
end
