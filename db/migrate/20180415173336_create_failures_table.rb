class CreateFailuresTable < ActiveRecord::Migration[5.1]
  def change
    create_table :failures_tables do |t|
      t.text :text
      t.string :error
    end
  end
end
