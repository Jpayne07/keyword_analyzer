# frozen_string_literal: true

require 'test_helper'

class ProjectTest < ActiveSupport::TestCase
  # setting max keywords, 1 keyword is already instantiated from fixtures
  Keyword::MAX_KEYWORDS_PER_USER = 5
  test 'project creation limits' do
    10.times do
      Project.create(name: Faker::Name.first_name, user_id: users(:one).id)
    end
    assert_not users(:one).projects.count > 10
  end

  test 'project cannot have more than 100,000 kws' do
    # from fixtures 1+4 (below)
    Keyword.transaction do
      4.times do
        Keyword.create!(
          name: 'test',
          url: 'test.com',
          brand: 'test',
          search_volume: 100,
          project_id: projects(:one).id
        )
      end
    end
    kw = Keyword.new(
      name: 'test',
      url: 'test.com',
      brand: 'test',
      search_volume: 100,
      project_id: projects(:one).id
    )
    # testing it does not save because there are 5 from above
    assert_not kw.save
  end
end
