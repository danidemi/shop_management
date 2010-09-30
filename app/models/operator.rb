class Operator < ActiveRecord::Base
  belongs_to :company

	acts_as_authentic # authlogic gem
end
