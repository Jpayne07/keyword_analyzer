
Keyword.delete_all
Project.destroy_all

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
#
Keyword.create!(name: "Keyword Topic #{101}",
    search_volume: 100000,
    project_id: projects.sample.id,
    url: 'Amos White.com',
    estimated_traffic: rand(500..1000),
    keyword_category: [ 'SEO', 'PPC', 'CRO' ].sample
)

Keyword.create!(name: "Keyword Topic #{102}",
    search_volume: rand(5000..100000),
    project_id: projects.sample.id,
    url: 'Amos White.com',
    estimated_traffic: rand(500..1000),
    keyword_category: [ 'SEO', 'PPC', 'CRO' ].sample
)
100.times do |i|
  Keyword.create!(
    name: "Keyword Topic #{i + 3}",
    search_volume: rand(5000..100000),
    project_id: projects.sample.id,
    url: Faker::Name.name+'.com',
    estimated_traffic: rand(500..1000),
    keyword_category: [ 'SEO', 'PPC', 'CRO' ].sample
  )
end


puts "Seeded #{Project.count} projects and #{Keyword.count} keywords."
