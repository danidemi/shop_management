class TrackAlertSentForMeeting < ActiveRecord::Migration
  def self.up
    add_column :meetings, :alert_sent, :boolean, {:default=>false, :null=>false}
  end

  def self.down
    remove_column :meetings, :alert_sent
  end
end
