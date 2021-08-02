class User < ApplicationRecord
  has_and_belongs_to_many :boards, join_table: 'users_boards'

  validates :name, :login, :password, presence: true

  validates :login, uniqueness: true

  validates :password, length: { minimum: 5}

  scope :enabled, -> { where(enabled: true) }

  def valid_password?(pass)
    password.present? && password == pass
  end

  def generate_token!

    # Token con expiracion
    token = SecureRandom.urlsafe_base64

    $client_redis.set("session_#{token}", id)

    token
  end

  def remove_token(token)
    $client_redis.del("session_#{token}")
  end

  def json
    {
      id: id,
      name: name,
      login: login,
      enabled: enabled,
    }
  end

  def self.find_by_token(htoken)
    id = $client_redis.get("session_#{htoken}")

    User.find_by(id: id)
  end
end
