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

#Log in form
post '/signin' do
    usera = params[:username]
    user = usera.downcase
    pass = params[:password]

    base_uri = 'https://dazzling-fire-2679.firebaseio.com/users'
    firebase = Firebase::Client.new(base_uri)
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

#Registration form
post '/signup' do
    user = params[:username]
    email = params[:email]
    cemail = params[:cemail]
    pass = params[:pass]
    cpass = params[:cpass]
        
    base_uri = 'https://dazzling-fire-2679.firebaseio.com/users'
    firebase = Firebase::Client.new(base_uri)
    usercheck = user + "/username"
    emailcheck = user + "/email"
    
    userexist = firebase.get(usercheck)
    emailexist = firebase.get(emailcheck)
    
    if user.length > 15 || user.length < 3
        @usererror = "Username is too long or too short. Must be between 3 and 15 characters."
        @regstatus = "Account creation failed. Please correct the errors below."
    end
    if email.length < 4 || cemail.length < 4
        @emailerror = "Email inputs are invalid"
        @regstatus = "Account creation failed. Please correct the errors below."
    end
    if pass.length < 6 || cpass.length < 6
        @passerror = "Password inputs are invalid"
        @regstatus = "Account creation failed. Please correct the errors below."
    end
    if email != cemail
        @emailerror2 = "Email inputs does not match"
        @regstatus = "Account creation failed. Please correct the errors below."
    end
    if pass != cpass
        @passerror2 = "Password inputs does not match"
        @regstatus = "Account creation failed. Please correct the errors below."
    end
    if userexist.body == "#{user}"
        @usererror = "Username already exist"
        @regstatus = "Account creation failed. Please correct the errors below."
    end
    if emailexist.body == "#{email}"
        @emailerror = "Email is in use"
        @regstatus = "Account creation failed. Please correct the errors below."
    end
    if @emailerror == nil && @passerror == nil && @usererror == nil && @emailerror2 == nil && @passerror2 == nil
        newuser = firebase.set(user, { username: user.downcase, email: email.downcase, password: pass })
        @regstatus = "Your account was created!"
    end
    @user, @email, @cemail, @pass, @cpass = user, email, cemail, pass, cpass
    erb :"signup.html"
end