class User < ApplicationRecord
  has_many :issues
  has_many :assigned_issues, class_name: 'Issue'
  has_secure_token :api_key

  # Comments
  has_many :comments
  has_many :commented_issues, through: :comments, source: :issue

  def self.sign_in_from_omniauth(auth)
      find_by(provider: auth['provider'], uid: auth['uid']) || create_user_from_omniauth(auth)
  end

  def self.create_user_from_omniauth(auth)
      create(
          provider: auth['provider'],
          uid: auth['uid'],
          name: auth['info']['name'],
          image_url: auth['info']['image'],
          nickname: auth['info']['nickname']
      )
  end

  def as_json_summary
    {
        name: self.name,
        nickname: self.nickname,
        image: { href: self.image_url }
    }
  end

  def as_json(options = {})
    super(options.reverse_merge(except: [:id, :api_key, :updated_at,
                                         :uid]))
  end
end
