class Customer < ActiveRecord::Base

	has_many :meetings, :dependent => :delete_all

end
