class Meeting < ActiveRecord::Base
  belongs_to :customer

	def date
		self.start ? self.start.to_date : nil 
	end

end
