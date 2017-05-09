class User < ApplicationRecord
    has_many :issues
    has_many :assigned_issues, :class_name => "Issue"
    has_many :comments
    has_secure_token :api_key

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
end
