# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
admin = User.new(:email => "admin@admin.com", :password => 'admin', :admin => true)
admin.created_on = Date.today
admin.save

user = User.new(:email => 'user1@user.com', :password => 'user')
user.created_on = Date.today
user.save

Movie.create(:name => "Звездные войны", :year => 1996)