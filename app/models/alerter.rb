require 'logger'

class Alerter

  def meetings_to_be_alerted(start, sender)
    window_end = start.advance :days => 3
    condition_date = [":start <= start AND start < :end", { :start => start, :end => window_end }]
    condition_not_sent = ["alert_sent IS NULL"]
		meetings = Meeting \
      .where(condition_date) \
      .where(condition_not_sent)

    report = Array.new

    meetings.each do |meeting|

      exception = nil

      begin
        sender.accept( meeting )
      rescue StandardError => exception
        #something went wrong
      end

      report << {
        :meeting_id => meeting.id, \
        :email => meeting.customer.email, \
        :error_reason => exception
      }

    end

    return report

  end

end

class AlerterSender
  def accept meeting
    unless meeting.customer.email.nil?
      message = AlertMailer.reminder( meeting );
      message.deliver
    end

    meeting.alert_sent = DateTime.now
    meeting.update_attribute :alert_sent, DateTime.now
    
  end
end


