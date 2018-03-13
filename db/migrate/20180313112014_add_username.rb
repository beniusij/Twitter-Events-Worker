class AddUsername < ActiveRecord::Migration[5.1]
  def change
    add_column :raw_tweets, :username, :string, null: false
  end
end
