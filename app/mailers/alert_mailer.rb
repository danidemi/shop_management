class AlertMailer < ActionMailer::Base
  default :from => "from@example.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.alert_mailer.reminder.subject
  #
  def reminder(meeting)
    @meeting = meeting
    mail(
      :from => @meeting.company.email_originator,
      :to => @meeting.customer.email,
      :subject => t(:reminder_mail_subject)
    )
      
  end
end
