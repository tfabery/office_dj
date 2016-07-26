require("bundler/setup")
Bundler.require(:default)
require 'warden'
require 'pry'
require 'rspotify'

Dir[File.dirname(__FILE__) + '/lib/*.rb'].each { |file| require file }

use Rack::Session::Cookie

use Warden::Manager do |manager|
  manager.default_strategies :password
  manager.serialize_into_session {|user| user.id}
  manager.serialize_from_session {|id| User.get(id)}
end

Warden::Manager.before_failure do |env,opts|
  env['REQUEST_METHOD'] = 'POST'
end

Warden::Strategies.add(:password) do
  def valid?
    params["username"] || params["password"]
  end

  def authenticate!
    name = params.fetch("password")
    user = User.first(:username => name )
    if user && user.authenticate(params.fetch("password"))
      success!(user)
    else
      fail!("Could not log in")
    end
  end

  def warden_handler
    env['warden']
  end

  def check_authentication
    unless warden_handler.authenticated?
      redirect '/login'
    end
  end

  def current_user
    warden_handler.user
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
    redirect '/'
  end

  get '/users/:id' do
    @user = User.get(params.fetch("id").to_i)
    # @dj = DJ.find_by({user_id: @user.id})
    erb(:main)
  end

  get '/main' do
    @tracks
    @songs = Library.last(10)
    erb :main
  end

  post '/song' do
    @tracks = RSpotify::Track.search(params.fetch 'name', limit: 10, market: 'US')
    @tracks.each do |track|
      binding.pry
      artist = track.artists[0].name
      album = track.album.name
      Library.create({name: track.name, artist: artist, popularity: track.popularity, album: album})
    end
    redirect('/main')
  end
