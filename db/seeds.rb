# frozen_string_literal: true

Keyword.delete_all
Project.destroy_all
Ngram.destroy_all
User.destroy_all

ActiveRecord::Base.connection.execute("DELETE FROM sqlite_sequence WHERE name='keywords'")
ActiveRecord::Base.connection.execute("DELETE FROM sqlite_sequence WHERE name='projects'")
User.create(email_address: 'jacobpayne007@gmail.com', password: 'password')
User.create(email_address: 'jpayne7@yahoo.com', password: 'password')
# Seed Projects
3.times do |i|
  Project.create!(
    name: "Project #{i + 1}",
    user_id: 1
  )
  i + 1
end
3.times do |i|
  Project.create!(
    name: "Projects #{i + 3}",
    user_id: 2
  )
end

# Fetch the created projects to associate keywords
projects = Project.all

100.times do |i|
  Keyword.create!(
    name: "Keyword Topic #{i + 3}",
    search_volume: rand(5000..100_000),
    project_id: projects.sample.id,
    url: "#{Faker::Name.name}.com",
    estimated_traffic: rand(500..1000),
    keyword_category: %w[SEO PPC CRO].sample,
    brand: %w[PACIFIC Uptick Mongo].sample
  )
end

Rails.logger.debug { "Seeded #{Project.count} projects and #{Keyword.count} keywords." }
