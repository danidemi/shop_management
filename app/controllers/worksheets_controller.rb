class WorksheetsController < ApplicationController

	def build_worksheet(a_date)

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

	def worksheet
		@date = params[:date] ? Date.parse(params[:date]) : Date.today
		@worksheets = build_worksheet( @date )
		@operators = Operator.select(:first_name, :last_name).joins(:company).where(:companies => {:id => current_operator.company.id})

    respond_to do |format|
    		format.html # index.html.erb
    		format.xml  { render :xml => @meetings }
  	end

#		@date = params[:date] ? Date.parse(params[:date]) : Date.today

#		# Compute start and end of the day.
#		day_start = DateTime.parse(@date.to_s)
#		day_end = day_start
#		day_start = day_start.advance :hours=>8
#		day_end = day_end.advance :hours=>18

#		# Prepare the worksheet data structure.
#		increment_field = :minutes
#		increment_amount = 30
#		@worksheets = Array.new
#		while day_start < day_end do

#			interval_start = day_start
#			interval_end = interval_start.advance( increment_field => increment_amount )

#			meetings = Meeting \
#				.joins(:company) \
#				.where(:companies => {:id => current_operator.company.id}) \
#				.where([":start < start AND start < :end", {:start => interval_start, :end => interval_end}]) \
#				.order(:start)		

#			@worksheets << {
#				:start => interval_start, 
#				:end => interval_end,
#				:meetings=>meetings}

#			day_start = interval_end
#		end

#	    respond_to do |format|
#      		format.html # index.html.erb
#      		format.xml  { render :xml => @meetings }
#    	end
	end

	def new_from_worksheet
		@customers = Customer.joins(:company).where(:companies => {:id => current_operator.company.id})

		@meeting = Meeting.new
		if params[:start] != nil then
			@meeting.start = DateTime.parse( params[:start] )
		end
		if params[:end] then
			@meeting.end = DateTime.parse( params[:end] )
		end

	end

	def create_into_worksheet
    @meeting = Meeting.new(params[:meeting])
		@meeting.company = current_operator.company

		if @meeting.save
			@worksheets = build_worksheet Date.parse(@meeting.start.to_s)
			@date = Date.parse(@meeting.start.to_s)
			@operators = Operator.select(:first_name, :last_name) \
				.joins(:company) \
				.where(:companies => {:id => current_operator.company.id})
			render :action => "worksheet"
		else
			render :action => "new_from_worksheet"
		end
	end

end
