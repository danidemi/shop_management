class CreateMeetings < ActiveRecord::Migration
  def self.up
    create_table :meetings do |t|
			t.references :company, :null => false
      t.references :customer, :null => false
			t.references :operator, :null => false
      t.datetime :start, :null => false
      t.datetime :end, :null => false
      t.text :notes

      t.timestamps
    end
  end

  def self.down
    drop_table :meetings
  end
end
