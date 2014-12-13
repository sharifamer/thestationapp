require 'instagram'

Parse.init :application_id => "D7ZF2F0A8jiQcXdeFOVZbeiPa1Jc1A4bxC2v7LHb",
           :api_key        => "XIQOIu68qpFwgjt2szgFNJfeChpdUT2UzaeF1EZX"

CALLBACK_URL = "http://thestationapp-c9-thestationapp.c9.io/auth/instagram/callback"

Instagram.configure do |config|
  config.client_id = "d456773548bc4d76896c71ef7e47bc97"
  config.client_secret = "df6eeca1ae40466885c84a11ca0d8033"
end

def searchInsta
    searchInsta = Parse::Query.new("Instagram")
    if searchInsta.eq("username", session[:user]).get == []
        return false
    else
      searchInsta.eq("username", session[:user])
    end
end
def instagramExist
  searchInsta != false ? true : false
end
def idToInfoInstagram(id, info)
    token = searchInsta.get[0]["instagram_token"]
    client = Instagram.client(:access_token => token)
    if info == "screen_name"
        screen_name = client.user(id).username
    elsif info == "name"
        name = client.user(id).full_name
    elsif info == "pic"
        pic = client.user(id).profile_picture
    elsif info == "banner_pic"
        if client.user(id).profile_banner_url?
            pic = client.user(id).profile_banner_url
        else
            pic = "images/coverholder.png"
        end
    end
end

get '/auth/instagram' do
  if searchInsta == false
    redirect Instagram.authorize_url(:redirect_uri => CALLBACK_URL)
  else
    redirect to "/instagramfeed"
  end
end

get '/auth/instagram/callback' do
  response = Instagram.get_access_token(params[:code], :redirect_uri => CALLBACK_URL)
 
    addInsta = Parse::Object.new("Instagram")
    addInsta["username"] = session[:user]
    addInsta["instagram_token"] = response.access_token
    addInsta["instagram_id"] = response.user.id
    addInsta.save
  
  redirect to "/instagramfeed"
end


get '/instagramfeed' do

  if searchInsta != false
    token = searchInsta.get[0]["instagram_token"]
    client = Instagram.client(:access_token => token)
    user = client.user
  
    @user_info = client.user
    @feed = client.user_media_feed(777)
    erb :"instagramfeed.html", :layout => :feedlayout
  else
    redirect to "/auth/instagram"
  end
end