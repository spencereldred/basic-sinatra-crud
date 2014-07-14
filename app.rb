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
    username = params[:username]
    password = params[:password]
    if params.values.include? ""
      if password == '' and username == ''
        flash[:notice] = "You need to fill in username and password"
      elsif password == ''
        flash[:notice] = "You need to fill in password"
      elsif username == ''
        flash[:notice] = "You need to fill in username"
      end
      redirect '/'
    end
    @database_connection.sql("INSERT INTO users (username,password) VALUES('#{username}', '#{password}')")
    flash[:notice] = "Thank you for registering"
    redirect '/'
  end

  post '/login' do
    username = params[:username]
    password = params[:password]

    current_user = @database_connection.sql("SELECT * FROM users WHERE username='#{username}' AND password='#{password}'").first
    if current_user
      flash[:notice] = "You are logged in"
      session[:user_id] = current_user['id']
    end
    redirect '/'
  end

  post '/logout' do
    session[:user_id] = nil
    flash[:notice] = "You are logged out"
    redirect '/'
  end


end
