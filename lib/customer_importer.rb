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
    @headers.each_pair do |key, value|
      puts key.to_s + "--" + value.to_s
    end
  end

  def csv=(csv_file)
    @csv = FasterCSV.new(csv_file, :col_sep => ";", :row_sep => :auto, :quote_char => '"', :headers => true, :return_headers => false )
  end

  def shift
    row = @csv.shift
#    puts "Shifted row:" + row.inspect
    customer = Customer.new

#    first_name_header = @headers[:first_name]
#    puts "first name header: " + first_name_header.inspect
#    puts "first name field:" + row[first_name_header].inspect
#    customer.firstName= row[first_name_header]

#    puts "firstName through key:" + row["Nome"].to_s
#    puts "firstName through index:" + row[0].to_s
#    puts "row headers :" + row.headers.inspect
#    puts "name header:" + row.headers[0].to_s
#    puts "test :" + (row.headers[0] == "Nome") ? "true":"false"

    customer.firstName= row[0]
    customer.lastName= row[@headers[:last_name]]
    customer.email= row[@headers[:email]]
    customer.landlinePhone= row[@headers[:landline_phone]]
    customer.mobilePhone= row[@headers[:mobile_phone]]
    customer.note= row[@headers[:notes]]
#    puts "Shifted customer:" + customer.inspect
    return customer
  end

  def for_each
    customer = shift
    while (customer != nil) do
#      puts "Customer:" + customer.inspect
      begin
        yield(customer)
      rescue
#        puts "Error importing customer row from CSV:[" + customer.to_s + "]"
      end

      unless @csv.eof? then
        customer = shift
      else
        customer = nil
      end
    end
  end

end