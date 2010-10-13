# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)

# Demo company, a lot of data

company_demo = Company.create(
	:name => "Demo s.p.a.",
  :email_originator => "Ufficio prenotazione Demo s.p.a. <escher75@gmail.com>"
)

operator_demo_1 = Operator.create(
	:username	=> "demo1",
	:password	=> "demo1",
	:password_confirmation => "demo1",
	:first_name => "Paolo",
	:last_name => "Sprits",
	:company_id => company_demo
)

operator_demo_2 = Operator.create(
	:username	=> "demo2",
	:password	=> "demo2",
	:password_confirmation => "demo2",
	:first_name => "Gianna",
	:last_name => "Libris",
	:company_id => company_demo
)

100.times { |i|
  i = i.to_s
  Customer.create(
	  :company_id => company_demo,
	  :firstName => "Cliente " + i,
	  :lastName => "Cliente " + i,
	  :landlinePhone => "+3902" + i, 
	  :mobilePhone => "+3902" + i, 
	  :email => "mail." + i + "@mail.com")
}



# A couple of companies

companies = Array.new

companies << Company.create(
	:name => "Estetica Le Fate s.r.l.",
  :email_originator => "Le Fate <escher75@gmail.com>"
)

companies << Company.create(
	:name => "Riparazioni Rapide s.n.c.",
  :email_originator => "Riparazioni Rapide <escher75@gmail.com>"
)



#Company[0]

operator1 = Operator.create(
	:username	=> "usr1",
	:password	=> "pwd1",
	:password_confirmation => "pwd1",
	:first_name => "John",
	:last_name => "Doe",
	:company_id => companies[0].id
)

operator2 = Operator.create(
	:username	=> "usr2",
	:password	=> "pwd2",
	:password_confirmation	=> "pwd2",
	:first_name => "Jean",
	:last_name => "Doe",
	:company_id => companies[0].id
)

puts "######################"
puts companies[0].to_s
puts companies[0].id
puts companies[0].name
puts "######################"

c1 = Customer.create(
	:company_id => companies[0].id,
	:firstName => "Carla " + companies[0].name, 
	:lastName => "Rossi", 
	:landlinePhone => "+39021111111", 
	:mobilePhone => "+39022222222", 
	:email => "mail@mail.com")

c2 = Customer.create(
	:company_id => companies[0].id,
	:firstName => "Susy " + companies[0].name, 
	:lastName => "Lambrusco", 
	:landlinePhone => "+39061111111", 
	:mobilePhone => "+39062222222", 
	:email => "indi@riz.zo")

c3 = Customer.create(
	:company_id => companies[0].id,
	:firstName => "Giovanna " + companies[0].name, 
	:lastName => "Tutta Panna", 
	:landlinePhone => "+39031111111", 
	:mobilePhone => "+39032222222", 
	:email => "posta@elettro.ni.ca"
)

Meeting.create(
	:company_id => companies[0].id,
	:customer_id => c1.id,
	:operator_id => operator1.id,
	:start => "2010-09-27 11:30:00",
	:end => "2010-09-27 12:30:00",
	:notes => "Unghie"
)

Meeting.create(
	:company_id => companies[0].id,
	:customer_id => c1.id,
	:operator_id => operator2.id,
	:start => "2010-09-27 16:30:00",
	:end => "2010-09-27 16:30:00",
	:notes => "Capelli"
)

Meeting.create(
	:company_id => companies[0].id,
	:customer_id => c2.id,
	:operator_id => operator1.id,
	:start => "2010-09-27 11:00:00",
	:end => "2010-09-27 12:00:00",
	:notes => "Decorazione"
)

Meeting.create(
	:company_id => companies[0].id,
	:customer_id => c2.id,
	:operator_id => operator2.id,
	:start => "2010-09-28 11:00:00",
	:end => "2010-09-28 12:00:00",
	:notes => "Decorazione x Martimonio"
)

Meeting.create(
	:company_id => companies[0].id,
	:customer_id => c3.id,
	:operator_id => operator1.id,
	:start => "2010-09-28 16:00:00",
	:end => "2010-09-28 17:00:00",
	:notes => "Unghie"
)

#Company[1]

operator3 = Operator.create(
	:username	=> "usr3",
	:password	=> "pwd3",
	:password_confirmation	=> "pwd3",
	:first_name => "Galileo",
	:last_name => "Galilei",
	:company_id => companies[1].id
)

