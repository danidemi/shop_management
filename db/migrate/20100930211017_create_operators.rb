class CreateOperators < ActiveRecord::Migration
  def self.up
    create_table :operators do |t|
      t.string :username
      t.string :crypted_password
			t.string :password_salt
			t.string :persistence_token
      t.string :first_name
      t.string :last_name
      t.references :company

      t.timestamps
    end
  end

  def self.down
    drop_table :operators
  end
end
