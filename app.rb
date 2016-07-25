require("bundler/setup")
Bundler.require(:default)

Dir[File.dirname(__FILE__) + '/lib/*.rb'].each { |file| require file }

get '/' do
  erb :index
end

get '/main' do
  erb :main
end

# get '/song' do
#   name = params.fetch 'song'
#   song = Library.find({name: name})
#   library_id = song.id
#   Song.create({library_id: library_id, dj_id: })
#   redirect :main
# end
