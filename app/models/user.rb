# frozen_string_literal: true

class User < ApplicationRecord
  has_many :tasks, foreign_key: 'user_id'

  def self.from_omniauth(auth)
    data = auth.info
    user = User.where(email: data['email']).first

    user ||= User.create(
      name: data['name'],
      status: true,
      email: data['email'],
      password: SecureRandom.hex
    )
    user
  end
end
