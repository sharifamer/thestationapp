require 'sinatra'
require 'firebase'
require 'pry'
require 'oauth'
require 'thin'
load 'twitter.rb'

#load 'instagram'
#load 'facebook.rb'


enable :sessions
set :server, 'thin'

get '/' do
    erb :"index.html"
end

get '/about' do 
    "This is <b>and</b> about page."
end



get '/signup' do
    erb :"signup.html"
end

get '/signin' do
    erb :"index.html"
end

get '/logout' do
    session.clear
    erb :"index.html"
end

get '/connect' do
    erb :"connect.html"
end

get '/facebook' do
    erb :"facebook.rb"
end

get '/slideshow' do 
    erb:"slideshow.html"
end

#Log in form
post '/signin' do
    usera = params[:username]
    user = usera.downcase
    pass = params[:password]

    usercheck = user + "/username"
    passmatch = user + "/password"
    
    checkuser = firebase.get(usercheck)
    checkpass = firebase.get(passmatch)
    if user.length <= 0
        @signinstatus = "No username was entered"
        erb :"index.html"
        elsif pass.length <= 0
        @signinstatus = "No password was entered"
        erb :"index.html"
    else 
        if checkuser.body == "#{user}"
            if checkpass.body == "#{pass}"
                session[:user] = usera
                @signinstatus = "Signed in"
                erb :"index.html"
            else
            @signinstatus = "The password does not match"
            erb :"index.html"
            end
        else
        @signinstatus = "That username does not exist"
        erb :"index.html"
        end
    end
end

