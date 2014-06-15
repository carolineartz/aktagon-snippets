class Users < ActiveRecord::Migration
  def up
    # Uncoment to create default user
    User.create! login: 'user', password: 'password'
  end
end
