class OperatorSessionsController < ApplicationController

  def new
		@operator_session = OperatorSession.new
  end

 def create  
   @operator_session = OperatorSession.new(params[:operator_session])  
   if @operator_session.save  
     flash[:notice] = "Successfully logged in."  
     redirect_to root_url  
   else  
     render :action => 'new'  
   end  
 end 

 def destroy  
   @operator_session = OperatorSession.find  
   @operator_session.destroy  
   flash[:notice] = "Successfully logged out."  
   redirect_to root_url  
 end

end
