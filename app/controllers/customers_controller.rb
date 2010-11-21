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

class CustomersController < ApplicationController

  # GET /customers
  # GET /customers.xml
  def index    
    @search = Search.new.parse(params)

    if @search.active?
      @customers = Customer \
        .joins(:company) \
        .where(Company.table_name => {:id => current_operator.company.id}) \
        .where(["firstName LIKE ? OR lastName LIKE ?", "%" + @search.term + "%", "%" + @search.term + "%"]) \
        .paginate :page => params[:page], :order => 'created_at ASC', :per_page => 10
    else
      @customers = Customer.joins(:company).where(Company.table_name => {:id => current_operator.company.id}) \
      .paginate :page => params[:page], :order => 'created_at ASC', :per_page => 10
    end
    

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @customers }
    end
  end

  # GET /customers/1
  # GET /customers/1.xml
  def show
    @customer = Customer.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @customer }
    end
  end

  # GET /customers/new
  # GET /customers/new.xml
  def new
    @customer = Customer.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @customer }
    end
  end

  # GET /customers/1/edit
  def edit
    @customer = Customer.find(params[:id])
  end

  # POST /customers
  # POST /customers.xml
  def create
    @customer = Customer.new(params[:customer])
		@customer.company = current_operator.company
    respond_to do |format|
      if @customer.save
        format.html { 
          redirect_to(
            @customer, 
            :notice => t(:customer_notice_correctly_created)
          ) 
        }
        format.xml  { render :xml => @customer, :status => :created, :location => @customer }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @customer.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /customers/1
  # PUT /customers/1.xml
  def update
    @customer = Customer.find(params[:id])

    respond_to do |format|
      if @customer.update_attributes(params[:customer])
        format.html { 
          redirect_to(
            @customer, 
            :notice => t(:customer_notice_correctly_updated) 
          ) 
        }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @customer.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /customers/1
  # DELETE /customers/1.xml
  def destroy
    @customer = Customer.find(params[:id])
    @customer.destroy

    respond_to do |format|
      format.html { redirect_to(customers_url) }
      format.xml  { head :ok }
    end
  end
end
