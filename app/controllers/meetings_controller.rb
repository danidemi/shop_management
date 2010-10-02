class MeetingsController < ApplicationController

	def worksheet

		@date = params[:date] ? Date.parse(params[:date]) : Date.today

		# Compute start and end of the day.
		day_start = DateTime.parse(@date.to_s)
		day_end = day_start
		day_start = day_start.advance :hours=>8
		day_end = day_end.advance :hours=>18

		# Prepare the worksheet data structure.
		increment_field = :minutes
		increment_amount = 30
		@worksheets = Array.new
		while day_start < day_end do

			interval_start = day_start
			interval_end = interval_start.advance( increment_field => increment_amount )

#			meetings = Meeting.where([
#				":start < start AND start < :end", 
#				{:start => interval_start, :end => interval_end}
#			]).order("start")		

			meetings = Meeting \
				.joins(:company) \
				.where(:companies => {:id => current_operator.company.id}) \
				.where([":start < start AND start < :end", {:start => interval_start, :end => interval_end}]) \
				.order(:start)		

			@worksheets << {
				:start => interval_start, 
				:end => interval_end,
				:meetings=>meetings}

			day_start = interval_end
		end

	    respond_to do |format|
      		format.html # index.html.erb
      		format.xml  { render :xml => @meetings }
    	end
	end

	def new_from_worksheet
    @customers = Customer.all

		@meeting = Meeting.new
		if params[:start] != nil then
			@meeting.start = DateTime.parse( params[:start] )
		end
		if params[:end] then
			@meeting.end = DateTime.parse( params[:end] )
		end

		render :action => :new
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

		@meeting = Meeting.new
		if @start != nil then
			@meeting.start = @start if @start != nil
		end
		if @end != nil then
			@meeting.end = @end 
		end
		logger.info "xxxxxxxxxx" + @meeting.start.to_s

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @meeting }
    end
  end

  # GET /meetings/1/edit
  def edit
	@customers = Customer.all
    @meeting = Meeting.find(params[:id])
  end

  # POST /meetings
  # POST /meetings.xml
  def create
    @meeting = Meeting.new(params[:meeting])
		@meeting.company = current_operator.company

    respond_to do |format|
      if @meeting.save
        format.html { redirect_to(@meeting, :notice => 'Meeting was successfully created.') }
        format.xml  { render :xml => @meeting, :status => :created, :location => @meeting }
      else
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
        format.html { redirect_to(@meeting, :notice => 'Meeting was successfully updated.') }
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
