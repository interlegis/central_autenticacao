# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
role = Role.create(name: 'admin')
Role.create(name: 'user')
user = User.create(first_name: 'Admin', last_name: 'Admin', cpf: '000.000.000-00', email: 'admin@admin.com', role: role, password: 'admin123')
ApiAccessesLevel.create(name: "Incomplete")
ApiAccessesLevel.create(name: "UserData")
ApiAccessesLevel.create(name: "BasicApiControl")
ApiAccessesLevel.create(name: "FullApiControl")
ApiAccess.create(user_id: user.id, api_accesses_level_id: 4, key: '6iwXud8cubFTlGWgd8FucO6kzT8BAFXRfd7eXlZLMT3bOgPuMg')