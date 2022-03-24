class ScheduledShowSerializer < ActiveModel::Serializer
  include ScheduledShowsHelper
  include ApplicationHelper
  include ActionView::Helpers::SanitizeHelper
  attributes :id, :start, :end, :title, :image_url, :thumb_image_url, :tweet_content, :description,
    :html_description, :slug, :recurring_interval, :hosted_by, :is_guest, :guest

  has_many :tracks, embed: :ids, key: :tracks
  has_many :djs, embed: :ids, key: :djs

  def hosted_by
    if object.performers.any?
      object.performers.first.username
    end
  end

  def djs
    object.performers
  end

  def tracks
    # don't show tracks if the show isn't over yet...
    if Time.now > object.end_at
      return object.tracks
    else
      return []
    end
  end

  def html_description
    html_pipeline(object.description)
  end

  def image_url
    if object.image.present?
      object.image_url
    end
  end

  def thumb_image_url
    if object.image.present?
      object.thumb_image_url
    end
  end

  def tweet_content
    tweet_text(object)
  end
end
