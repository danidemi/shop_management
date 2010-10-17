class Customer < ActiveRecord::Base

  # Relations
	belongs_to :company 	# foreign key: company_id
	has_many :meetings, :dependent => :delete_all

  # Validation
  validates_presence_of :firstName, :lastName
  validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i, :allow_blank => true

  # Pagination
  cattr_reader :per_page

end
