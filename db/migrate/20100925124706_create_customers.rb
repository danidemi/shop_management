class CreateCustomers < ActiveRecord::Migration
  def self.up
    create_table :customers do |t|
			t.references :company
      t.string :firstName
      t.string :lastName
      t.string :landlinePhone
      t.string :mobilePhone
      t.string :email

      t.timestamps
    end
  end

  def self.down
    drop_table :customers
  end
end
