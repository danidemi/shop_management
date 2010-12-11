class Meeting < ActiveRecord::Base

  belongs_to :customer 	# foreign key: customer_id
	belongs_to :company 	# foreign key: company_id
	belongs_to :operator	# foreign key: operator_id

  validates_presence_of :start, :end
  validate  :start_date_cannot_be_in_the_past, \
            :end_date_cannot_be_in_the_past, \
            :start_should_precede_end

	def date
		self.start ? self.start.to_date : nil 
	end

  # Validation 

  def start_date_cannot_be_in_the_past
    errors.add(:start, I18n.translate('activerecord.errors.models.meeting.attributes.start.in_the_past')) if  
      !start.blank? and start < Date.today 
  end 

  def end_date_cannot_be_in_the_past
    errors.add(:end, I18n.translate('activerecord.errors.models.meeting.attributes.end.in_the_past')) if 
      !self.end.blank? and self.end < Date.today
  end 

  def start_should_precede_end
    errors.add(:start, I18n.translate('activerecord.errors.models.meeting.attributes.start.after_end')) if  
      !start.blank? and !self.end.blank? and self.end < start
  end

  # Business

  # Whether the alert for this meeting has been already delivered or not
  def alerted?
    !alert_sent.nil?
  end

end
