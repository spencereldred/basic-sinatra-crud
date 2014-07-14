require "sinatra"
require "active_record"
require "./lib/database_connection"
require "rack-flash"

class App < Sinatra::Application
  enable :sessions
  use Rack::Flash

  def initialize
    super
    @database_connection = DatabaseConnection.establish(ENV["RACK_ENV"])
  end

  get "/" do
    erb :home
  end

  get '/register' do
    erb :register
  end

  post '/register' do
    @database_connection.sql("INSERT INTO users (username,password) VALUES('#{params[:username]}', '#{params[:password]}')")
    flash[:notice] = "Thank you for registering"
    redirect '/'
  end


end
