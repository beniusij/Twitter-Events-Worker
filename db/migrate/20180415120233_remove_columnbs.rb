class RemoveColumnbs < ActiveRecord::Migration[5.1]
  def change
    remove_column :raw_tweets, :is_checked
    remove_column :raw_tweets, :is_valid
  end
end
