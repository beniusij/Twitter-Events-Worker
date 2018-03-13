class CreateTwitterAccounts < ActiveRecord::Migration[5.1]
  def change
    create_table :twitter_accounts do |t|

      t.string :twitter_name

      t.timestamps
    end
  end
end
