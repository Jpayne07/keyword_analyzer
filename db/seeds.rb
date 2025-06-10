# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
# Clear existing data
Keyword.delete_all
Project.delete_all

# Reset auto-increment index for SQLite
ActiveRecord::Base.connection.execute("DELETE FROM sqlite_sequence WHERE name='keywords'")
ActiveRecord::Base.connection.execute("DELETE FROM sqlite_sequence WHERE name='projects'")

# Seed Projects
3.times do |i|
  Project.create!(
    name: "Project #{i + 1}",
    user_id: 1  # Make sure user_id: 1 exists or change this
  )
end
  3.times do |i|
  Project.create!(
    name: "Project #{3 + i}",
    user_id: 2  # Make sure user_id: 1 exists or change this
  )
end

# Fetch the created projects to associate keywords
projects = Project.all

# Seed Keywords
100.times do |i|
  Keyword.create!(
    name: "Keyword Topic #{i + 1}",
    search_volume: rand(5000..100000),
    project_id: projects.sample.id,
    url: Faker::Name.name+'.com'
  )
end

puts "Seeded #{Project.count} projects and #{Keyword.count} keywords."
