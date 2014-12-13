require 'oauth'
require 'twitter'

Parse.init :application_id => "D7ZF2F0A8jiQcXdeFOVZbeiPa1Jc1A4bxC2v7LHb",
           :api_key        => "XIQOIu68qpFwgjt2szgFNJfeChpdUT2UzaeF1EZX"

consumer_key = 'ZFN35beMHxovlqKB2KRIGoH4X'
consumer_secret = 'jm64owKNK6IYU6ojhWSePvSPRYqSWQV6ntPAp0Z8g817tG3SNT'

def searchTwitter
    searchTwitter = Parse::Query.new("Twitter")
    if searchTwitter.eq("username", session[:user]).get == []
        return false
    else
        searchTwitter.eq("username", session[:user])
    end
end
def twitterExist
  searchTwitter != false ? true : false
end
def tweetStrip(tweet)
    strip = tweet.text.dup 
    if tweet.hashtags?
        strip.gsub!(/(?<hash>#\S*)/, '<a href="#">\k<hash></a>' )
    end
    if tweet.user_mentions?
        strip.gsub!(/(?<at>@\S*)/, '<a href="#">\k<at></a>' )
    end
    if tweet.urls?
        strip.gsub!(/(?<link>http:\/\/t.co\S*)/, '<a href="\k<link>">\k<link></a>' )
    end
    strip
end
def idToInfoTwitter(id, info)
    client = Twitter::REST::Client.new do |config|
        config.consumer_key        = 'ZFN35beMHxovlqKB2KRIGoH4X'
        config.consumer_secret     = 'jm64owKNK6IYU6ojhWSePvSPRYqSWQV6ntPAp0Z8g817tG3SNT'
    end
    if info == "screen_name"
        screen_name = client.user(id).screen_name
    elsif info == "name"
        name = client.user(id).name
    elsif info == "pic"
        pic = client.user(id).profile_image_url
    elsif info == "banner_pic"
        if client.user(id).profile_banner_url?
            pic = client.user(id).profile_banner_url
        else
            pic = "images/coverholder.png"
        end
    end
end

get '/auth/twitter' do
    if searchTwitter == false
        @callback_url = "http://thestationapp-c9-thestationapp.c9.io/auth/twitter/callback"
        @consumer = OAuth::Consumer.new(consumer_key, consumer_secret, :site => "https://api.twitter.com", :authorize_path => '/oauth/authorize')
        
        @request_token = @consumer.get_request_token(:oauth_callback => @callback_url)
        session[:request_token] = @request_token
        redirect to @request_token.authorize_url(:oauth_callback => @callback_url)
    else
        redirect to "/twitterfeed"
    end
end

get '/auth/twitter/callback' do
    access_token = session[:request_token].get_access_token(:oauth_verifier => params["oauth_verifier"])
    oauth_token = access_token.params[:oauth_token]
    oauth_token_secret = access_token.params[:oauth_token_secret]
    user_id = access_token.params[:user_id]
 
    addTwitter = Parse::Object.new("Twitter")
    addTwitter["username"] = session[:user]
    addTwitter["twitter_token"] = oauth_token
    addTwitter["twitter_secret"] = oauth_token_secret
    addTwitter["twitter_id"] = user_id
    addTwitter.save
    
    redirect to "/twitterfeed"
end

get  '/twitterfeed' do
    if searchTwitter != false
        access_token = searchTwitter.get[0]["twitter_token"]
        access_token_secret = searchTwitter.get[0]["twitter_secret"]
        
        client = Twitter::REST::Client.new do |config|
            config.consumer_key        = consumer_key
            config.consumer_secret     = consumer_secret
            config.access_token        = access_token
            config.access_token_secret = access_token_secret
        end
        
        @user_info = client.user
        @timeline = client.home_timeline(count: 5)
        erb :"twitterfeed.html", :layout => :feedlayout
    else
    redirect to "/auth/twitter"
    end
end

get '/twitterprofile' do
    access_token = searchTwitter.get[0]["twitter_token"]
    access_token_secret = searchTwitter.get[0]["twitter_secret"]
        
        client = Twitter::REST::Client.new do |config|
            config.consumer_key        = consumer_key
            config.consumer_secret     = consumer_secret
            config.access_token        = access_token
            config.access_token_secret = access_token_secret
        end
        @user_info = client.user
        @timeline = client.user_timeline
        erb :"twitterfeed.html", :layout => :feedlayout
end

get '/twitterlogin' do
end