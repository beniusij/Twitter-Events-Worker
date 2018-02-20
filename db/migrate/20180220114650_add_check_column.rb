class AddCheckColumn < ActiveRecord::Migration[5.1]
  def change
    add_column :raw_tweets, :is_checked, :boolean, default: false, null: false
  end
end
