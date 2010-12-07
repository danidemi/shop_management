require 'test_helper'

class AlertMailerTest < ActionMailer::TestCase

  test "reminder" do

    meeting = meetings(:one)

    mail = AlertMailer.reminder( meeting )
    assert_equal I18n.t(:reminder_mail_subject), mail.subject
    assert_equal [meeting.customer.email], mail.to
    assert_equal [meeting.company.email_originator], mail.from
    assert_match "#{meeting.company.name}", mail.body.encoded
  end

end
