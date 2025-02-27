class DjSerializer < ActiveModel::Serializer
  attributes :id, :username, :image_url, :bio, :image, :style, :email,
    :image_thumb_url, :image_medium_url, :profile_publish, :pronouns, :role, :fruits_affinity,
    :homepage, :fruit_ticket_balance

  def image_url
    if object.image.present?
      object.image.url
    end
  end

  def image_thumb_url
    if object.image.present?
      object.image.url(:thumb)
    end
  end

  def image_medium_url
    if object.image.present?
      object.image.url(:medium)
    end
  end

  def fruits_affinity
    Redis.current.hgetall "datafruits:user_fruit_count:#{object.username}"
  end
end
