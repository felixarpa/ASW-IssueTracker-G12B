class Issue < ApplicationRecord
    belongs_to :user
    has_many :assigned_users, :class_name => "User"
end
