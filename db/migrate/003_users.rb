class Users < ActiveRecord::Migration
  def up
    User.create! login: 'user', password: 'password'
  end

  def down
    User.delete_all
  end
end
