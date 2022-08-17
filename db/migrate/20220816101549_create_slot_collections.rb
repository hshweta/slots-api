class CreateSlotCollections < ActiveRecord::Migration[5.0]
  def change
    create_table :slot_collections do |t|
      t.references :slot, foreign_key: true
      t.integer :capacity
      t.datetime :start_time
      t.datetime :end_time

      t.timestamps
    end
  end
end
