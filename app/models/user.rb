class User < ApplicationRecord
    validates :username, uniqueness: true, length: {minimum:3}, presence: true
    has_and_belongs_to_many :boards, join_table: "users_boards"
end