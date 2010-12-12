require 'test_helper'

class CounterSender

  attr_reader :count, :last_meeting

  def initialize
    @count = 0
  end

  def accept(meeting)
    increment meeting
  end

  def increment(meeting)
    @count = @count + 1
    @last_meeting = meeting
  end
end

class CounterSenderError < CounterSender
  def accept(meeting)
    increment meeting
    raise "Generic error"
  end
end

class AlerterSenderTest < ActiveSupport::TestCase

  test "should send a message" do
    meeting = Meeting.find(meetings(:to_send).id)
    sender = AlerterSender.new
    assert_nil meeting.alert_sent
    sender.accept(meeting)

    meeting_db = Meeting.find(meeting.id)
    assert_not_nil meeting_db.alert_sent
  end

end

class AlerterTest < ActiveSupport::TestCase

  test "should gather and return info about selected meetings" do
    alerter = Alerter.new
    sender = CounterSender.new
    report = nil
    assert_nothing_raised do
      report = alerter.meetings_to_be_alerted DateTime.parse('2010-02-14'), sender
    end
    assert_instance_of Array, report
    assert_equal 4, report.length
    assert_instance_of Hash, report[0]
    assert_not_nil report[0][:meeting_id]
    assert_equal 'charlize@mail.com', report[0][:email]
    assert_nil report[0][:error_reason]

    sender = CounterSenderError.new
    report = nil
    assert_nothing_raised do
      report = alerter.meetings_to_be_alerted DateTime.parse('2010-02-14'), sender
    end
    assert_instance_of Array, report
    assert_equal 4, report.length
    assert_instance_of Hash, report[0]
    assert_not_nil report[0][:meeting_id]
    assert_equal 'charlize@mail.com', report[0][:email]
    assert_not_nil report[0][:error_reason]
  end

  test "should not select meetings if alert has been already sent" do
    a = Alerter.new
    count = 0
    the_meeting = nil
    s = CounterSender.new
    a.meetings_to_be_alerted DateTime.parse('2010-03-14'), s
    assert_equal 1, s.count
  end

  test "should go on even if delegate raises error" do
    a = Alerter.new
    count = 0
    the_meeting = nil
    s = CounterSenderError.new
    assert_nothing_raised do
      a.meetings_to_be_alerted DateTime.parse('2010-02-14'), s
    end
    assert_equal 4, s.count
  end

  test "should find all meetings inside window" do
    a = Alerter.new
    count = 0
    the_meeting = nil
    s = CounterSender.new
    a.meetings_to_be_alerted DateTime.parse('2010-02-14'), s
    assert_equal 4, s.count
  end

  test "should find meetings if window is not empty" do
    a = Alerter.new
    count = 0
    the_meeting = nil
    s = CounterSender.new
    a.meetings_to_be_alerted DateTime.parse('2010-01-14'), s
    assert_equal 1, s.count
    assert_equal meetings(:meeting_charlize_1), s.last_meeting
  end

  test "should not find meetings if window is empty" do
    a = Alerter.new
    count = 0
    s = CounterSender.new
    a.meetings_to_be_alerted DateTime.parse('2010-01-10'), s
    assert_equal 0, s.count
  end

  test "could be instantiated" do
    assert_not_nil Alerter.new
  end

end


