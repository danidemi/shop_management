# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)

c1 = Customer.create(
	:firstName => "Carla", 
	:lastName => "Rossi", 
	:landlinePhone => "+39021111111", 
	:mobilePhone => "+39022222222", 
	:email => "mail@mail.com")

c2 = Customer.create(
	:firstName => "Susy", 
	:lastName => "Lambrusco", 
	:landlinePhone => "+39061111111", 
	:mobilePhone => "+39062222222", 
	:email => "indi@riz.zo")

c3 = Customer.create(
	:firstName => "Giovanna", 
	:lastName => "Tutta Panna", 
	:landlinePhone => "+39031111111", 
	:mobilePhone => "+39032222222", 
	:email => "posta@elettro.ni.ca"
)

Meeting.create(
	:start => "2010-09-27 11:30:00",
	:end => "2010-09-27 12:30:00",
	:customer_id => c1.id,
	:notes => "Unghie"
)

Meeting.create(
	:start => "2010-09-27 16:30:00",
	:end => "2010-09-27 16:30:00",
	:customer_id => c1.id,
	:notes => "Capelli"
)

Meeting.create(
	:start => "2010-09-27 11:00:00",
	:end => "2010-09-27 12:00:00",
	:customer_id => c2.id,
	:notes => "Decorazione"
)

Meeting.create(
	:start => "2010-09-28 11:00:00",
	:end => "2010-09-28 12:00:00",
	:customer_id => c2.id,
	:notes => "Decorazione x Martimonio"
)

Meeting.create(
	:start => "2010-09-28 16:00:00",
	:end => "2010-09-28 17:00:00",
	:customer_id => c3.id,
	:notes => "Unghie"
)

