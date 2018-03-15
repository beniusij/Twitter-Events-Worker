class AddTweetPlace < ActiveRecord::Migration[5.1]
  def change
    add_column :raw_tweets, :place, :string
  end
end
