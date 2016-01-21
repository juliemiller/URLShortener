# == Schema Information
#
# Table name: shortened_urls
#
#  id         :integer          not null, primary key
#  short_url  :string           not null
#  long_url   :string           not null
#  user_id    :string           not null
#  created_at :datetime
#  updated_at :datetime
#

class ShortenedUrl < ActiveRecord::Base

  validates :short_url, :presence => true, :uniqueness => true
  validates :long_url, :presence => true
  validates :user_id, :presence => true

  belongs_to :submitter,
    foreign_key: :user_id,
    primary_key: :id,
    class_name: 'User'

  has_many :visits,
    foreign_key: :short_url_id,
    primary_key: :id,
    class_name: 'Visit'

  has_many :visitors,
    -> { distinct },
    through: :visits,
    source: :visitor

  has_many :taggings,
    foreign_key: :short_url_id,
    primary_key: :id,
    class_name: 'Tagging'

  has_many :tags,
    through: :taggings,
    source: :tag_topic

  def self.random_code
    unique = false
    short_url = ""

    until unique
      short_url = SecureRandom.urlsafe_base64
      unique = true unless ShortenedUrl.exists?(short_url: 'short_url')
    end

    short_url
  end

  def self.create_for_user_and_long_url!(user, long_url)
    ShortenedUrl.create!(:short_url => ShortenedUrl.random_code, long_url: long_url, user_id: user.id)
  end

  def num_clicks
    visits.count
  end

  def num_uniques
    visitors.count
  end

  def num_recent_uniques
    visits.select(:user_id).distinct.where("updated_at >= '#{90.minutes.ago}'").count
  end

end
