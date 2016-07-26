require 'rubygems'
require 'data_mapper'
require 'dm-postgres-adapter'
require 'bcrypt'

DataMapper.setup(:default, 'postgres://*******:*******@localhost/office_dj_test')


class User < ActiveRecord::Base
  include DataMapper::Resource
  include BCrypt

  property :id, Serial, :key => true
  property :username, String, :length => 3..50
  property :password, BCryptHash


  has_and_belongs_to_many :songs
  has_many :djs

  def authenticate(attempted_password)
    if self.password == attempted_password
      true
    else
      false
    end
  end
end

DataMapper.finalize
DataMapper.auto_upgrade!


if User.count == 0
  @user = User.create(username: "admin")
  @user.password = "admin"
  @user.save
end
