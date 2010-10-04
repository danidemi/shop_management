class Worksheets

	attr_accessor :operators, :time_intervals

	def build(a_date)

		# Retrieve the list of operators
		@operators = Operator.select(:first_name, :last_name).joins(:company).where(:companies => {:id => current_operator.company.id})

		# Compute the list of time intervals
		day_start = DateTime.parse(a_date.to_s)
		day_end = day_start
		day_start = day_start.advance :hours=>8
		day_end = day_end.advance :hours=>18
		increment_field = :minutes
		increment_amount = 30
		@time_intervals = Array.new
		while day_start < day_end do
			interval_start = day_start
			interval_end = interval_start.advance( increment_field => increment_amount )
			@time_intervals << {:start => interval_start, :end => interval_end}
			day_start = interval_end
		end

		@meetings = {}

		@operators.each do |operator|
			@time_intervals.each do |interval|
				meetings = Meeting \
					.joins(:company) \
					.joins(:operator) \
					.where(:companies => {:id => current_operator.company.id}) \
					.where(:operators => {:id => operator.id}) \
					.where([":start < start AND start < :end", {:start => interval_start, :end => interval_end}]) \
					.order(:start)		

				@meetings[interval] = {}
				@meetings[interval][operator] = meetings;
			end 
		end

		return self
	end

	def meetings_for(time_interval, operator)
		@meetings[time_interval][operator]
	end

end
