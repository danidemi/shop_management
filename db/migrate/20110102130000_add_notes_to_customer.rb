class AddNotesToCustomer < ActiveRecord::Migration
  def self.up
    add_column :customers, :note, :text, {:null=>true}
  end

  def self.down
    remove_column :customers, :note
  end
end

