require 'alert_job.rb'
class MeetingsController < ApplicationController

#  def send_reminder
#    @meeting = Meeting.find(params[:id])
#    mailMessage = AlertMailer.reminder(@meeting)
#    #mailMessage.delay.deliver
#    mailMessage.deliver
#    redirect_to(@meeting, :notice => t(:reminder_notice_correctly_sent))   
#  end

  def send_reminder_old
    @meeting = Meeting.find(params[:id])
    mailMessage = AlertMailer.reminder(@meeting)
#    mailMessage.delivery_method :smtp,   { :address   => "mail.xxxxxx",
#                                :port                 => 25,
#                                :domain               => 'localhost.localdomain',
#                                :user_name            => 'xxxx@xxxx.xxx',
#                                :password             => 'xxxxx',
#                                :authentication       => false,
#                                :enable_starttls_auto => true  }
    mailMessage.delivery_method :sendmail
#    mailMessage.delay.deliver
    mailMessage.deliver
    redirect_to(@meeting, :notice => t(:reminder_notice_correctly_sent))   
  end

  def send_reminder
    @meeting = Meeting.find(params[:id])
    alert_job = AlertJob.new
    alert_job.notifier_method = "reminder"
    alert_job.meeting_id = params[:id]
    Delayed::Job.enqueue alert_job
    redirect_to(@meeting, :notice => t(:reminder_notice_correctly_sent))   
  end

  def send_reminder_with_mail
    @meeting = Meeting.find(params[:id])
    mail = Mail.new do
        from @meeting.company.email_originator
        to @meeting.customer.email
        subject t(:reminder_mail_subject)
        body mail_body
    end
  end

  # GET /meetings
  # GET /meetings.xml
  def index

    @meetings = Meeting.joins(:company).where(:companies => {:id => current_operator.company.id})

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @meetings }
    end
  end

  # GET /meetings/1
  # GET /meetings/1.xml
  def show
    @meeting = Meeting.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @meeting }
    end
  end

  # GET /meetings/new
  # GET /meetings/new.xml
  def new
		@customers = Customer.joins(:company).where(:companies => {:id => current_operator.company.id})
		@operators = Operator.joins(:company).where(:companies => {:id => current_operator.company.id})

		@meeting = Meeting.new
		if @start != nil then
			@meeting.start = @start if @start != nil
		end
		if @end != nil then
			@meeting.end = @end 
		end

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @meeting }
    end
  end

  # GET /meetings/1/edit
  def edit
		@customers = Customer.all
		@operators = Operator.joins(:company).where(:companies => {:id => current_operator.company.id})
    @meeting = Meeting.find(params[:id])
  end

  # POST /meetings
  # POST /meetings.xml
  def create
    @meeting = Meeting.new(params[:meeting])
		@meeting.company = current_operator.company

    respond_to do |format|
      if @meeting.save
        format.html { redirect_to(@meeting, :notice => t(:meeting_notice_correctly_created) ) }
        format.xml  { render :xml => @meeting, :status => :created, :location => @meeting }
      else
    		@customers = Customer.joins(:company).where(:companies => {:id => current_operator.company.id})
    		@operators = Operator.joins(:company).where(:companies => {:id => current_operator.company.id})
        format.html { render :action => "new" }
        format.xml  { render :xml => @meeting.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /meetings/1
  # PUT /meetings/1.xml
  def update
    @meeting = Meeting.find(params[:id])

    respond_to do |format|
      if @meeting.update_attributes(params[:meeting])
        format.html { redirect_to(@meeting, :notice => t(:meeting_notice_correctly_updated)) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @meeting.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /meetings/1
  # DELETE /meetings/1.xml
  def destroy
    @meeting = Meeting.find(params[:id])
    @meeting.destroy

    respond_to do |format|
      format.html { redirect_to(meetings_url) }
      format.xml  { head :ok }
    end
  end
end
