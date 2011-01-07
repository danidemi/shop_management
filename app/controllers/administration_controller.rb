require 'csv'

class AdministrationController < ApplicationController

  def index
  end

  def customers_upload
    customers_file = params[:customers]
    out = String.new
    out = customers_file.tempfile.path

    CSV.open(customers_file.tempfile.path, 'r', :col_sep => ";", :row_sep => :auto, :quote_char => '"', :headers => true, :return_headers => true) do |row|
      out = out + "\n${row}"
    end

#    csv = CSV.new( \
#      customers_file.tempfile.path, \
#      { \
#        :col_sep => ";", \
#        :row_sep => :auto, \
#        :quote_char => '"', \
#        :headers => true, \
#        :return_headers => true
#      }
#    )




    flash[:notice]= t('administration.customers.import.success')

    render :content_type => 'text/plain', :text => out
    #redirect_to :action => "index"
  end

end