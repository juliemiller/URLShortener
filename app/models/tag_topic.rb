# == Schema Information
#
# Table name: tag_topics
#
#  id         :integer          not null, primary key
#  tag_name   :string           not null
#  created_at :datetime
#  updated_at :datetime
#

class TagTopic < ActiveRecord::Base

  validates :tag_name, uniqueness: true, presence: true

  has_many :taggings,
    foreign_key: :tag_id,
    primary_key: :id,
    class_name: 'Tagging'

  has_many :shortened_urls,
    through: :taggings,
    source: :shortened_url

  has_many :visitors,
    through: :shortened_urls,
    source: :visits

  def most_popular_urls_for_tag
    ShortenedUrl.find_by_sql(<<-SQL)
      SELECT
        shortened_urls.*
      FROM
        tag_topics
      JOIN
        taggings ON tag_topics.id = taggings.tag_id
      JOIN
        shortened_urls ON taggings.short_url_id = shortened_urls.id
      JOIN
        visits ON visits.short_url_id = shortened_urls.id
      WHERE
        tag_topics.tag_name = '#{self.tag_name}'
      GROUP BY
        shortened_urls.id
      ORDER BY
        COUNT(shortened_urls.id) DESC
      LIMIT
        1

    SQL
  end
end
