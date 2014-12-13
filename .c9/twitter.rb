require 'oauth'
require 'twitter'
require 'pry'

consumer_key = 'ZFN35beMHxovlqKB2KRIGoH4X'
consumer_secret = 'jm64owKNK6IYU6ojhWSePvSPRYqSWQV6ntPAp0Z8g817tG3SNT'

get '/auth/twitter' do
    @callback_url = "http://stationapp-c9-stationapp.c9.io/auth/twitter/callback"
    @consumer = OAuth::Consumer.new("ZFN35beMHxovlqKB2KRIGoH4X","jm64owKNK6IYU6ojhWSePvSPRYqSWQV6ntPAp0Z8g817tG3SNT", :site => "https://api.twitter.com", :authorize_path => '/oauth/authorize')
    
    @request_token = @consumer.get_request_token(:oauth_callback => @callback_url)
    session[:request_token] = @request_token
    redirect to @request_token.authorize_url(:oauth_callback => @callback_url)
end

get '/auth/twitter/callback' do
    access_token = session[:request_token].get_access_token(:oauth_verifier => params["oauth_verifier"])
  oauth_token = access_token.params[:oauth_token]
  oauth_token_secret = access_token.params[:oauth_token_secret]
  user_id = access_token.params[:user_id]
  
    base_uri = 'https://dazzling-fire-2679.firebaseio.com/users' + session[:user]
    firebase = Firebase::Client.new(base_uri)
   
    addtwitter = firebase.set("twitter", {oauth_token: oauth_token, oauth_token_secret: oauth_token_secret, user_id: user_id})
"Account Created. Go to http://stationapp-c9-stationapp.c9.io/twitterinfo"

end

get  '/feed' do
     base_uri = 'https://dazzling-fire-2679.firebaseio.com/users' + session[:user] + '/twitter'
    firebase = Firebase::Client.new(base_uri)

    access_token = firebase.get(base_uri + '/oauth_token')
    access_token_secret = firebase.get(base_uri + '/oauth_token_secret')
    user_id = firebase.get(base_uri + '/user_id')
    
    @client = Twitter::REST::Client.new do |config|
        config.consumer_key        = consumer_key
        config.consumer_secret     = consumer_secret
        config.access_token        = access_token.body
        config.access_token_secret = access_token_secret.body
    end
    erb :"station.html"
end