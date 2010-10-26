class Operator < ActiveRecord::Base

	acts_as_authentic # authlogic gem

  # Relation
  belongs_to :company # foreign key: company_id

  # Validation
  validates_presence_of :first_name, :last_name
end
