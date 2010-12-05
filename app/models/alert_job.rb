#class AlertJob < Struct.new("SuperAlert", :notifier_method,:meeting_id)
class AlertJob

  attr_accessor :notifier_method, :meeting_id

  def perform

    begin
      puts 'performing'
      puts 'notifier_method ' + notifier_method
      puts 'meeting_id ' + meeting_id
      meeting = Meeting.find(meeting_id)
      if(meeting)
        puts 'meeting found is ' + meeting.inspect
        #message = AlertMailer.send notifier_method, meeting
        puts AlertMailer.respond_to?( notifier_method )
        message = AlertMailer.reminder( meeting );
        puts 'message body:' + message.body.decoded
        #puts 'message header:' + message.header
        message.deliver
      else
        puts 'null meeting'
      end
    rescue Exception => e
      puts 'something went wrong:' + e 
    ensure
      puts 'perform done'
    end
    
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
