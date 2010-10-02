class CreateOperators < ActiveRecord::Migration
  def self.up
    create_table :operators do |t|
      t.string :username, :null => false
      t.string :crypted_password, :null => false
			t.string :password_salt, :null => false
			t.string :persistence_token
      t.string :first_name, :null => false
      t.string :last_name, :null => false
      t.references :company
      t.timestamps
    end
  end

  def self.down
    drop_table :operators
  end
end
