# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)

Customer.create(
	:firstName => "Carla", 
	:lastName => "Rossi", 
	:landlinePhone => "+39021111111", 
	:mobilePhone => "+39022222222", 
	:email => "mail@mail.com")

Customer.create(
	:firstName => "Susy", 
	:lastName => "Lambrusco", 
	:landlinePhone => "+39061111111", 
	:mobilePhone => "+39062222222", 
	:email => "mail@mail.com")

