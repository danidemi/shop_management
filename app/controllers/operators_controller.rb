class OperatorsController < ApplicationController

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
