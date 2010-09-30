class Customer < ActiveRecord::Base

	belongs_to :company 	# foreign key: company_id

	has_many :meetings, :dependent => :delete_all

end
