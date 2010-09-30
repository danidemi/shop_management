class CreateMeetings < ActiveRecord::Migration
  def self.up
    create_table :meetings do |t|
			t.references :company
      t.references :customer
      t.datetime :start
      t.datetime :end
      t.text :notes

      t.timestamps
    end
  end

  def self.down
    drop_table :meetings
  end
end
