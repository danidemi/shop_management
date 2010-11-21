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
        .where(Company.table_name => {:id => current_operator.company.id}) \
        .where(["first_name LIKE ? OR last_name LIKE ?", "%" + @search.term + "%", "%" + @search.term + "%"]) \
        .paginate :page => params[:page], :order => 'last_name ASC', :per_page => 10
    else
      @operators = Operator.joins(:company).where(Company.table_name => {:id => current_operator.company.id}) \
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
    @operator.company = current_operator.company
    respond_to do |format|
		  if @operator.save
        format.html { 
          redirect_to(@operator, :notice => t('operator.notice.correctly_created'))
        }
        format.xml  { render :xml => @operator, :status => :created, :location => @operator }
		  else
        format.html { render :action => "new" }
        format.xml  { render :xml => @customer.errors, :status => :unprocessable_entity }
		  end			
    end
  end

  # GET /customers/1
  # GET /customers/1.xml
  def show
    @operator = Operator.find(params[:id])
    if(@operator.company == current_operator.company)
      respond_to do |format|
        format.html # show.html.erb
        format.xml  { render :xml => @customer }
      end
    end
  end

	def edit
		@operator = Operator.find(params[:id])
		if @operator.update_attributes(params[:id])
			flash[:notice] = t('operator.notice.correctly_updated')
		else
			render :action => 'edit'
		end
	end

  # PUT /customers/1
  # PUT /customers/1.xml
  def update
    @operator = Customer.find(params[:id])

    respond_to do |format|
      if @operator.update_attributes(params[:operator])
        format.html { 
          redirect_to(
            @operator, 
            :notice => t('operator.notice.correctly_updated') 
          ) 
        }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @operator.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /customers/1
  # DELETE /customers/1.xml
  def destroy
    @operator = Operator.find(params[:id])
    @operator.destroy

    respond_to do |format|
      format.html { redirect_to(operators_url) }
      format.xml  { head :ok }
    end
  end

end
