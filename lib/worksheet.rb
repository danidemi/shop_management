class Worksheets

	attr_accessor :operators, :time_intervals

  def build_operator_headers
		operators = Operator \
      .select(:first_name, :last_name) \
      .joins(:company) \
      .where(:companies => {:id => current_operator.company.id})
    operatorHeaders = Array.new
    operators.each{ |operator|
      operatorHeaders << {:id => operator.id, :label => operator.first_name + " " + operator.last_name};
    }
    operatorHeaders << {:id => nil, :label => "noop"};
    return operatorHeaders
  end

  def build_time_rows(a_date)
		day_start = DateTime.parse(a_date.to_s)
		day_end = day_start
		day_start = day_start.advance :hours=>8
		day_end = day_end.advance :hours=>18
		increment_field = :minutes
		increment_amount = 30
		time_intervals = Array.new
		while day_start < day_end do
			interval_start = day_start
			interval_end = interval_start.advance( increment_field => increment_amount )
			time_intervals << {:start => interval_start, :end => interval_end}
			day_start = interval_end
		end
    return time_intervals
  end  

  def build_meetings_list(a_date)
		return Meeting.joins(:company).where(:companies => {:id => current_operator.company.id})
  end

  def build_empty_worksheet(operators, intervals)
    worksheet = Array(operators.count);
    heads.count.times{ |i|
      worksheet[i] = Array(intervals.count)
    }
    return worksheet
  end

  def dododo(a_date)
    heads = build_operator_headers
    rows = build_time_rows a_date
    meets = build_meetings_list a_date
    worksheet = build_empty_worksheet

    if(meets && !meets.empty?)
      meeting_index = 0
      heads.count.times{ |operator_index|
        rows.count.times{ |time_interval_index|

          operator = heads[operator_index]
          time_interval = rows[time_interval_index]

          if(meeting_index < meets.count)
            meeting = meets[meeting_index]
            while( meeting && meeting.operator_id == operator[:id] && time_interval[:start] <= meeting.start && time_interval[:end] < meeting.start )
              if(!worksheet[operator_index, time_interval_index]){
                worksheet[operator_index, time_interval_index] = Array.new
              }
              worksheet[operator_index, time_interval_index] << meeting
              meeting_index++
              if(meeting_index < meets.count)
                meeting = meets[meeting_index]
              else
                meeting = nil
              end
            end
          end
        
        }
      }
    end

  end

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
