class Company < ActiveRecord::Base

	has_many :customers,	:dependent => :delete_all
	has_many :meetings, 	:dependent => :delete_all
	has_many :operators

end
