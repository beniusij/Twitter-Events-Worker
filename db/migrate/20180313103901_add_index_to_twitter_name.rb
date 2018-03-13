class AddIndexToTwitterName < ActiveRecord::Migration[5.1]
  def change
    add_index :twitter_accounts, :twitter_name, unique: true
  end
end
