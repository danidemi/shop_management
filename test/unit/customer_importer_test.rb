require 'test_helper'
require 'fastercsv'
require 'customer_importer'

class CustomerImporterTest < ActiveSupport::TestCase

  test "should import a real file" do
    I18n.locale = :it
    csv_file = File.new(File.dirname(File.expand_path(__FILE__)) + "/customer_importer_real_test_it.csv", "r")
    importer = CustomerImporter.new
    importer.csv=csv_file

    succededs = 0
    failures = 0
    progressive = 0
    
    company_id = Company.find(:all)[0].id
    assert_not_nil(company_id)

    importer.for_each do |customer|
      progressive = progressive + 1
      customer.company_id = company_id
      if customer.save then
        succededs = succededs + 1
      else
        failures = failures + 1
        #puts customer.errors.to_s
      end
    end

    assert_equal(2, progressive);
    assert_equal(0, failures);

  end

  test "should go on even when there are errors" do
    I18n.locale = :ch
    importer = CustomerImporter.new
    importer.csv = @csv_file
    times = 0
    importer.for_each do |customer|
      times = times + 1
      raise "An Error"
    end
    assert_equal(@expected_records, times)
  end

  test "should retrieve the customers with blocks using italian headers" do
    I18n.locale = :it
    importer = CustomerImporter.new
    importer.csv = @csv_file_it
    times = 0
    importer.for_each do |customer|
      times = times + 1
    end
    assert_equal(@expected_records_it, times)
  end

  test "should retrieve the customers with blocks using standard headers" do
    I18n.locale = :ch
    importer = CustomerImporter.new
    importer.csv = @csv_file
    times = 0
    importer.for_each do |customer|
      times = times + 1
    end
    assert_equal(@expected_records, times)
  end

  test "should retrieve the customers using standard headers" do
    I18n.locale = :ch
    importer = CustomerImporter.new
    importer.csv = @csv_file
    customer = importer.shift
    assert_not_nil(customer)
    assert_instance_of(Customer, customer)
    assert_equal("John", customer.firstName)
    assert_equal("Doe", customer.lastName)
    assert_equal("foo@bar.com", customer.email)
    assert_equal("+1111111111", customer.landlinePhone)
    assert_equal("+2222222222", customer.mobilePhone)
    assert_equal("notes", customer.note)
    customer = importer.shift
    assert_not_nil(customer)
    assert_instance_of(Customer, customer)
    assert_equal("Jean", customer.firstName)
    assert_equal("Doe", customer.lastName)
    assert_equal("an@email.com", customer.email)
    assert_equal("+3333333333", customer.landlinePhone)
    assert_equal("+4444444444", customer.mobilePhone)
    assert_equal("another note", customer.note)
  end

  test "should be initialized" do
    assert_nothing_thrown {
      CustomerImporter.new
    }
  end

  test "what happen with a multi line field" do
    @csv.shift
    @csv.shift
    assert_equal("note line 1\nnote line 2\nnote line 3", @csv.shift["Notes"])
  end

  test "what happen at the end of file" do
    @expected_records.times do
      row = @csv.shift
      assert_not_nil(row)
    end
    # here the file is terminated

    row = @csv.shift
    assert_nil(row)
  end

  test "how to read lines" do
    assert File.file?(@csv_file)
    row = @csv.shift
    assert_not_nil(row)
    assert_instance_of(FasterCSV::Row, row)
    assert_equal("John", row["First Name"])
    assert_equal("Doe", row["Last Name"])
    assert_equal("foo@bar.com", row["Email"])
    assert_equal("+1111111111", row["Landline"])
    assert_equal("+2222222222", row["Mobile"])
    assert_equal("notes", row["Notes"])
    row = @csv.shift
    assert_not_nil(row)
    assert_instance_of(FasterCSV::Row, row)
    assert_equal("Jean", row["First Name"])
    assert_equal("Doe", row["Last Name"])
    assert_equal("an@email.com", row["Email"])
    assert_equal("+3333333333", row["Landline"])
    assert_equal("+4444444444", row["Mobile"])
    assert_equal("another note", row["Notes"])
  end

  def setup
    @csv_file = File.new(File.dirname(File.expand_path(__FILE__)) + "/customer_importer_test.csv", "r")
    @csv = FasterCSV.new(@csv_file, :col_sep => ";", :row_sep => :auto, :quote_char => '"', :headers => true, :return_headers => false )
    @expected_records = 4
    @csv_file_it = File.new(File.dirname(File.expand_path(__FILE__)) + "/customer_importer_test_it.csv", "r")
    @csv_it = FasterCSV.new(@csv_file_it, :col_sep => ";", :row_sep => :auto, :quote_char => '"', :headers => true, :return_headers => false )
    @expected_records_it = 2
  end

end