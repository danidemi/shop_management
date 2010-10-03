class Meeting < ActiveRecord::Base

  belongs_to :customer 	# foreign key: customer_id
	belongs_to :company 	# foreign key: company_id
	belongs_to :operator	# foreign key: operator_id

	def date
		self.start ? self.start.to_date : nil 
	end

end
