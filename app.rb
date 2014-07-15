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
    users = @database_connection.sql("SELECT * FROM users WHERE id != #{session[:user_id].to_i}")
    fishes = @database_connection.sql("SELECT * FROM fishes  WHERE user_id=#{session[:user_id].to_i}")
    erb :home, locals: {users: users, fishes: fishes}
  end

  get '/order/:order'do
    if params[:order] == "ascending"
      order = "ASC"
    elsif params[:order] == "descending"
      order = "DESC"
    else
      redirect '/'
    end
    users = @database_connection.sql("SELECT * FROM users WHERE id != #{session[:user_id].to_i} ORDER BY username #{order}")
    fishes = @database_connection.sql("SELECT * FROM fishes  WHERE user_id=#{session[:user_id].to_i}")
    erb :home, locals: {users: users, fishes: fishes}
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
      redirect '/register'
    else
      begin
        @database_connection.sql("INSERT INTO users (username,password) VALUES('#{username}', '#{password}')")
        flash[:notice] = "Thank you for registering"
        redirect '/'
      rescue
        flash[:notice] = "Username is already in use, choose another username"
        redirect '/register'
      end
    end
  end

  get "/add_fish" do
    erb :new_fish
  end

  post "/add_fish" do
    name = params[:name]
    url = params[:url]
    user_id = session[:user_id].to_i
    @database_connection.sql("INSERT INTO fishes (name, url, user_id) VALUES ('#{name}', '#{url}', #{user_id})")

    redirect "/"
  end

  get "/delete/:name" do
    name = params[:name]
    @database_connection.sql("DELETE FROM users WHERE username='#{name}'")
    redirect "/"
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
