class CreateEvents < ActiveRecord::Migration[5.1]
  def change
    create_table :events do |t|
      t.string  :place
      t.date    :date, null: false
      t.time    :time
      t.text    :keywords

      t.timestamps
    end
  end
end
