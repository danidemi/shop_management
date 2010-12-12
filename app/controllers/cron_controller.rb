class CronController < ApplicationController

  def send_alerts
    logger.info "Star sending alerts about meetings expiring in next 3 days"
    now = Time.now
    report = Alerter.new.meetings_to_be_alerted DateTime.now, AlerterSender.new
    elapsed = Time.now - now
    elapsed_msg = "Sending terminated in #{elapsed * 1000} msec"

    text = ""
    report.each do |item|
      text = text + "\n#{item.inspect}"
    end

    logger.info elapsed_msg
    text = text + "\n#{elapsed_msg}"

    render :content_type => 'text/plain', :text => text
  end

end
