class AddUsernameColumn < ActiveRecord::Migration[5.1]
  def change
    add_column :events, :username, :string
  end
end
