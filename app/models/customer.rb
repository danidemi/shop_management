class Customer < ActiveRecord::Base

  # Relations
	belongs_to :company 	# foreign key: company_id
	has_many :meetings, :dependent => :delete_all

  # Pagination
  cattr_reader :per_page

end
