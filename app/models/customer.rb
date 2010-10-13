class Customer < ActiveRecord::Base

  # Relations
	belongs_to :company 	# foreign key: company_id
	has_many :meetings, :dependent => :delete_all

  # Validation
  validates_presence_of :firstName, :lastName
  #validates_format_of :email, :with => /\b[A-Z0-9._%-]+@[A-Z0-9.-]+\.[A-Z]{2,4}\b/

  # Pagination
  cattr_reader :per_page

end
