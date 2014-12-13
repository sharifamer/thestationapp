require 'sinatra'
require 'parse-ruby-client'
require 'pry'
require 'json'
require 'koala'
require 'obscenity/rack'

require_relative  'twitter.rb'
require_relative  'instagram.rb'
require_relative  'facebook.rb'
require_relative  'users.rb'

#ruby server.rb -p $PORT -o $IP (Reset Server)
#ruby [ ""Target File"" ] -p $PORT -o $IP (Apparently, Capitalization Matters)
#pkill -9 ruby (terminate terminal command after CMND+C (MAC)     CTRL+C (PC)


enable :sessions
set :session_secret, 'R3dfjj9394076AnDo93M'




use Rack::Obscenity, reject: { params: [:fuck, :shit] } , message: "We dont allow profanity! please change your content." 

use Rack::Obscenity, reject: { params: [:dick, :faggot] } , message: "We dont allow profanity! please change your content." 
begin
    
rescue Exception => e
end
use Rack::Obscenity, reject: { params: [:bitch, :slut] } , message: "We dont allow profanity! please change your content." 

use Rack::Obscenity, reject: { params: [:asshole, :piss] } , message: "We dont allow profanity! please change your content." 



get '/' do
    #binding.pry
    erb :"accounts.html"
    
end

get '/signup' do
    erb :"signup.html"
end

get '/logout' do
    session.clear
    redirect to "/"
end

get '/facebook' do
    erb :"facebook.rb"
end

get '/slideshow' do 
    erb :"slideshow.html"
end

get '/test' do
    erb :"test.html"
end

get '/lostinfo' do
    erb :"lostinfo.html"
end

get '/feed' do
    erb :"feed.html"
end

get '/login' do
    erb :"login.html"
end


