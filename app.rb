require("bundler/setup")
Bundler.require(:default)
require 'warden'
require 'pry'
require 'rspotify'

Dir[File.dirname(__FILE__) + '/lib/*.rb'].each { |file| require file }

use Rack::Session::Cookie, :secret => "WookieFoot"

use Warden::Manager do |manager|
  manager.default_strategies :password
  manager.failure_app = FailureApp
  manager.serialize_into_session {|user| user.id}
  manager.serialize_from_session {|id| User.get(id)}
end

use Warden::Manager do |config|
    config.scope_defaults :default,
      strategies: [:password],
      action: '/unauthenticated'
    config.failure_app = self
  end

Warden::Manager.before_failure do |env,opts|
  env['REQUEST_METHOD'] = 'POST'
end

Warden::Strategies.add(:password) do
  def valid?
    params["username"] || params["password"]
  end

  def authenticate!
    name = params.fetch("username")
    user = User.first(:username => name )
    if user && user.authenticate(params.fetch("password"))
      success!(user)
    else
      fail!("Could not log in")
    end
  end
end

#######Routing########

  get '/' do
    erb :index
  end

  post '/user' do
    env['warden'].authenticate!
    if env['warden'].authenticated?
      redirect "/users/#{env['warden'].user.id}"
    else
      redirect '/'
    end
  end

  post '/unauthenticated' do
    erb :index
  end

  post '/song' do
    @tracks = RSpotify::Track.search(params.fetch 'name', limit: 10, market: 'US')
    @tracks.each do |track|
      Library.create({name: track.name})
    end
    redirect('/main')
  end

  get '/main' do
    @songs = Library.first(10)
    erb :main
  end

  get '/users/:id' do
    unless env['warden'].authenticated?
      redirect '/login'
    end
    @user = User.get(params.fetch("id").to_i)
    # @dj = DJ.find_by({user_id: @user.id})
    erb(:main)
  end

  get '/signup' do
    erb :signup_form
  end

  post '/users/new' do
    username = params.fetch("new_username")
    password = params.fetch("new_password")
    @user = User.first_or_create({:username => username, :password => password})
    erb :main
  end

  get '/login' do
    redirect '/'
  end

  get '/logout' do
    env['warden'].logout
    redirect '/'
  end


class FailureApp < Sinatra::Application
  post '/unauthenticated' do
    erb :failed
  end
end
