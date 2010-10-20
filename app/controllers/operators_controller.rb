class Search

  def term
    @term
  end

  def parse(params)
    if params && params[:search] && params[:search][:term] && params[:search][:term].length > 0
      @term = params[:search][:term]
    end 
    return self
  end

  def active?
    return (@term != nil)
  end

end

class OperatorsController < ApplicationController

  def index    
    @search = Search.new.parse(params)

    if @search.active?
      @operators = Operator \
        .joins(:company) \
        .where(:companies => {:id => current_operator.company.id}) \
        .where(["first_name LIKE ? OR last_name LIKE ?", "%" + @search.term + "%", "%" + @search.term + "%"]) \
        .paginate :page => params[:page], :order => 'last_name ASC', :per_page => 10
    else
      @operators = Operator.joins(:company).where(:companies => {:id => current_operator.company.id}) \
      .paginate :page => params[:page], :order => 'last_name ASC', :per_page => 10
    end
    

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @customers }
    end
  end

  def new
		@operator = Operator.new
  end

  def create
		@operator = Operator.new(params[:operator])
		if @operator.save
			flash[:notice] = "Successfully registered operator."
			redirect_to root_url
		else
			redirect_to :action => :new
		end			
  end

	def edit
		@operator = Operator.find(params[:id])
		if @operator.update_attributes(params[:id])
			flash[:notice] = "Successfully updated operator."
		else
			render :action => 'edit'
		end
	end

end
