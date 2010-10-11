class AlertJob < Struct.new(:notifier_method,:meeting_id)

  def perform
    puts 'performing'
    puts 'notifier_method' + self.notifier_method
    puts 'meeting_id ' + self.meeting_id
    meeting = Meeting.find(self.meeting_id)
    message = AlertMailer.send(self.notifier_method, meeting)
    puts 'message ' + message
    message.deliver
  end

  def enqueue(job)
    puts 'AlertJob/enqueue'
  end

  def before(job)
    puts 'AlertJob/start'
  end

  def after(job)
    puts 'AlertJob/after'
  end

  def success(job)
    puts 'AlertJob/success'
  end

  def error(job, exception)
    puts 'AlertJob/error'
  end

  def failure
    puts 'AlertJob/failure'
  end

end 
