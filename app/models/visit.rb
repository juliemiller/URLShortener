# == Schema Information
#
# Table name: visits
#
#  id           :integer          not null, primary key
#  short_url_id :integer          not null
#  user_id      :integer          not null
#  created_at   :datetime
#  updated_at   :datetime
#

class Visit < ActiveRecord::Base

  validates :short_url_id, :presence => true
  validates :user_id, :presence => true

  belongs_to :visitor,
    foreign_key: :user_id,
    primary_key: :id,
    class_name: 'User'

  belongs_to :shortened_url,
    foreign_key: :short_url_id,
    primary_key: :id,
    class_name: 'ShortenedUrl'

  def self.record_visit!(user, shortened_url)
    Visit.create!(:short_url_id => shortened_url.id, :user_id => user.id)
  end

end
