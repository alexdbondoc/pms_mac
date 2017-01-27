# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


request = Request.new
request.category_id = Category.first.id
request.date_created = Time.now
request.user_id = User.first.id
request.officer_id = Officer.first.id
request.department_id = Department.first.id
request.request_lines_attributes = [{type_id: Type.first.id, product_id: Product.first.id, unit_id: Unit.first.id}]
request.reason = 'TTTTTTEEESSSTTTTTT'
request.save