class Operator < ActiveRecord::Base
  belongs_to :company # foreign key: company_id

	acts_as_authentic # authlogic gem
end
