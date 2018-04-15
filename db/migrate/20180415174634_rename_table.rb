class RenameTable < ActiveRecord::Migration[5.1]
  def change
    rename_table :failures_tables, :failures
  end
end
