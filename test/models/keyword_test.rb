# frozen_string_literal: true

require 'test_helper'

class KeywordTest < ActiveSupport::TestCase
  Keyword::MAX_KEYWORDS_PER_USER = 5
  test 'Keyword is not longer than 50 chars' do
    keywords(:one).name = 'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa'
    print(keywords(:one).name.size)
    assert_not keywords(:one).save
  end

  test 'user cannot have more than 150,000 kws' do
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

    assert_not kw.save
  end
end
