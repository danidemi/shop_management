class Meeting < ActiveRecord::Base

  belongs_to :customer # foreign key: customer_id

	def date
		self.start ? self.start.to_date : nil 
	end

end
