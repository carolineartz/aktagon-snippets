require 'bcrypt'

class User < ActiveRecord::Base
  attr_accessor :password
  before_save :encrypt_password

  validates :email, uniqueness: true, allow_blank: true
  validates :login, presence: true, uniqueness: true
  validates :password, confirmation: true
  validates :password, on: :create, presence: true

  has_many :snippets, counter_cache: true

  def to_param
    "#{id}-#{name.gsub(/[^a-z0-9]+/i, '-')}"
  end

  def self.authenticate(login, password)
    user = where('login = ?', login).first
    if user && user.password_hash == BCrypt::Engine.hash_secret(password, user.password_salt)
      user
    else
      nil
    end
  end

  def encrypt_password
    if password.present?
      self.password_salt = BCrypt::Engine.generate_salt
      self.password_hash = BCrypt::Engine.hash_secret(password, password_salt)
    end
  end
end
