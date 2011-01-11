require 'customer_importer'

class AdministrationController < ApplicationController

  def index
  end

  def customers_upload
    logger.info "Received CSV customer file."

    logger.info "Retrieving CSV customer file from request."
    customers_file = params[:customers]
    logger.info "CSV customer file retrieved."

    logger.info "CSV customer file #{customers_file.inspect}"
    csv_file = File.new(customers_file.tempfile.path, "r")

    importer = CustomerImporter.new
    importer.csv=csv_file

    @log = Array.new
    succededs = 0
    failures = 0
    progressive = 0
    importer.for_each do |customer|

      customer_description = (customer.firstName!=nil) ? customer.firstName : ""
      customer_description += " "
      customer_description += (customer.lastName!=nil) ? customer.lastName : ""

      progressive = progressive + 1
      customer.company_id = current_operator.company.id
      if customer.save then
        succededs = succededs + 1
        #It does not seem a good idea to log correct importation
        #@log << I18n.t('administration.customers.import.log.success', :counter=>progressive, :customer=>customer_description, :error=>nil)
      else
        failures = failures + 1
        logger.error "Error importing customer #{customer.inspect} from CSV: #{customer.errors.to_s}"
        @log << I18n.t('administration.customers.import.log.fail', :counter=>progressive, :customer=>customer_description, :errors=>customer.errors.to_s)
        #@log << "errore"
      end
    end


    if failures == 0 then
      key = :notice
    elsif succededs == 0 then
      key = :error
    else
      key = :warning
    end

    flash[key]= t('administration.customers.import.outcome', :succeded => succededs, :failed => failures)
    render :index
  end

end