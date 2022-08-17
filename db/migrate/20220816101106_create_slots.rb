class CreateSlots < ActiveRecord::Migration[5.0]
  def change
    create_table :slots do |t|
      t.datetime :start_time
      t.datetime :end_time
      t.integer :total_capacity

      t.timestamps
    end
  end
end
