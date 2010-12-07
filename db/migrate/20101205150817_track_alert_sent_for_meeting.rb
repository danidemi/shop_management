class TrackAlertSentForMeeting < ActiveRecord::Migration
  def self.up
    add_column :meetings, :alert_sent, :datetime, {:default=>nil, :null=>true}
  end

  def self.down
    remove_column :meetings, :alert_sent
  end
end
