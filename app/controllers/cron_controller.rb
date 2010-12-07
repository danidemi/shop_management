class CronController < ApplicationController

  def send_alerts
    logger.info "Star sending alerts about meetings expiring in next 3 days"
    now = Time.now
    Alerter.new.meetings_to_be_alerted DateTime.now, AlerterSender.new
    elapsed = Time.now - now
    logger.info "Sending terminated in #{elapsed * 1000} msec"
    render :text => "OK"
  end

end
