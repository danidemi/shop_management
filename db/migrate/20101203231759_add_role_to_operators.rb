class AddRoleToOperators < ActiveRecord::Migration
  def self.up
    add_column :operators, :role, :string, {:default=>'operator', :null=>false}
  end

  def self.down
    remove_column :operators, :role
  end
end
