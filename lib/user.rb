require 'rubygems'
require 'data_mapper'
require 'dm-postgres-adapter'
require 'bcrypt'

DataMapper.setup(:default, 'postgres://Guest:guest@localhost/Guest')

class User < ActiveRecord::Base
  include DataMapper::Resource
  include BCrypt

  property :id, Serial, :key => true
  property :username, String, :length => 3..50
  property :password, BCryptHash

  has_and_belongs_to_many :songs
  has_many :djs
end

DataMapper.finalize
DataMapper.auto_upgrade!
