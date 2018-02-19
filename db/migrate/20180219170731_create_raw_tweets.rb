class CreateRawTweets < ActiveRecord::Migration[5.1]
  def change
    create_table :raw_tweets do |t|
      t.integer :tweet_id
      t.text :full_text
      t.string :uri

      t.timestamps
    end
  end
end
