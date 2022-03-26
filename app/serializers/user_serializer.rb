class UserSerializer < ActiveModel::Serializer
  attributes :id, :username, :email, :time_zone, :role, :avatar_url, :style, :avatar, :avatar_filename, :pronouns
  has_many :social_identities
  has_many :user_follows, embed: :ids, key: :user_follows, embed_in_root: true, each_serializer: UserFollowSerializer

  def user_follows
    object.user_follows
  end

  def avatar_url
    if object.image.present?
      object.image.url(:thumb)
    end
  end

  def avatar
    if object.image.present?
      {
        basename: object.image_file_name,
        attachment: "avatars",
        updated_at: object.image.updated_at
      }
    end
  end

  def avatar_filename
    if object.image.present?
      object.image_file_name
    end
  end
end
