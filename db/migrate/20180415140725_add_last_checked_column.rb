class AddLastCheckedColumn < ActiveRecord::Migration[5.1]
  def change
    add_column :twitter_accounts, :last_checked, :timestamp
  end
end
