class CustomerImporter

  def initialize
    @headers = {
      :first_name => I18n.t('administration.customers.csv.headers.first_name', :default => 'First Name'), \
        :last_name => I18n.t('administration.customers.csv.headers.last_name', :default => 'Last Name'), \
        :landline_phone => I18n.t('administration.customers.csv.headers.landline_phone', :default => 'Landline'), \
        :mobile_phone => I18n.t('administration.customers.csv.headers.mobile_phone', :default => 'Mobile'), \
        :email => I18n.t('administration.customers.csv.headers.email', :default => 'Email'), \
        :notes => I18n.t('administration.customers.csv.headers.notes', :default => 'Notes')
    }
    #@headers.each_pair do |key, value|
    #  puts key.to_s + "--" + value.to_s
    #end
  end

  def csv=(csv_file)
    @csv = FasterCSV.new(csv_file, :col_sep => ";", :row_sep => :auto, :quote_char => '"', :headers => true, :return_headers => false )
  end

  def shift
    row = @csv.shift
    customer = Customer.new
    customer.firstName= row[@headers[:first_name]]
    customer.lastName= row[@headers[:last_name]]
    customer.email= row[@headers[:email]]
    customer.landlinePhone= row[@headers[:landline_phone]]
    customer.mobilePhone= row[@headers[:mobile_phone]]
    customer.note= row[@headers[:notes]]
    return customer
  end

  def for_each
    customer = shift
    while (customer != nil) do

      begin
        yield(customer)
      rescue
        puts "Error importing customer row from CSV:[" + customer.to_s + "]"
      end

      unless @csv.eof? then
        customer = shift
      else
        customer = nil
      end
    end
  end

end