require 'sinatra'
require 'sinatra/reloader'
require 'tilt/erubis'
require 'yaml'

configure do
  enable :sessions
  set :session_secret, 'secret'
end

get '/' do
  erb :index
end

get '/:contacts' do
  @contacts = YAML.load_file("data/#{params[:contacts]}.yml")
  erb :contacts
end

get '/add/:contacts' do
  erb :add_contacts
end

post '/add/:contacts' do
  contacts = YAML.load_file("data/#{params[:contacts]}.yml")
  contacts[params[:name]] = {email: params[:email], phone: params[:phone]}

  File.open("data/#{params[:contacts]}.yml", "w"){ |file| YAML.dump(contacts, file) }
  session[:message] = "Congrats! Another #{params[:contacts]} contact has been added to your list."
  redirect "/#{params[:contacts]}"
end

post '/delete/:contacts/:name' do
  contacts = YAML.load_file("data/#{params[:contacts]}.yml")
  contacts.delete(params[:name])
  File.open("data/#{params[:contacts]}.yml", "w"){ |file| YAML.dump(contacts, file) }

  session[:message] = "I am sorry that you lost a #{params[:contacts]} contact!"

  redirect "/#{params[:contacts]}"
end