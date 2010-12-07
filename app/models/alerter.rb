require 'logger'

class Alerter

  def meetings_to_be_alerted(start, sender)
    window_end = start.advance :days => 3
    condition_date = [":start <= start AND start < :end", { :start => start, :end => window_end }]
    condition_not_sent = ["alert_sent IS NULL"]
		meetings = Meeting \
      .where(condition_date) \
      .where(condition_not_sent)

    meetings.each do |meeting|
      begin
        sender.accept( meeting )
      rescue
        #something went wrong
        #logger.error "An error occurred in #{self.class.to_s} while delegating meeting #{meeting.to_s} to #{sender.to_s}"
      end
    end
  end

end

class AlerterSender
  def accept meeting

    puts meeting.inspect

    message = AlertMailer.reminder( meeting );
    puts 'message body:' + message.body.decoded
    message.deliver

    meeting.alert_sent = DateTime.now
    puts meeting.inspect
    #meeting.save!
    meeting.update_attribute :alert_sent, DateTime.now
    
  end
end


