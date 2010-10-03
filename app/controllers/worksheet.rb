class Worksheets

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

		@operators.each |operator| do
			@time_intervals.each |interval| do
				meetings = Meeting \
					.joins(:company) \
					.where(:companies => {:id => current_operator.company.id}) \
					.where([":start < start AND start < :end", {:start => interval_start, :end => interval_end}]) \
					.order(:start)		
			end 
		end

		# Compute start and end of the day
		day_start = DateTime.parse(a_date.to_s)
		day_end = day_start
		day_start = day_start.advance :hours=>8
		day_end = day_end.advance :hours=>18

		# Prepare the worksheet data structure
		increment_field = :minutes
		increment_amount = 30
		worksheets = Array.new

		# Populate the worksheet
		while day_start < day_end do

			interval_start = day_start
			interval_end = interval_start.advance( increment_field => increment_amount )

			meetings = Meeting \
				.joins(:company) \
				.where(:companies => {:id => current_operator.company.id}) \
				.where([":start < start AND start < :end", {:start => interval_start, :end => interval_end}]) \
				.order(:start)		

			worksheets << {
				:start => interval_start, 
				:end => interval_end,
				:meetings=>meetings}

			day_start = interval_end
		end

		return worksheets
	end

	def operators
	end

	def time_intervals
	end

	def meetings_for(operator, time_interval)
	end

def
