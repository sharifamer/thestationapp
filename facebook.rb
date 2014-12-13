require 'koala'
require 'oauth'

APP_ID = 1496999683915780

APP_SECRET = 'ab17cbaf972b5574088fdfa9d9f00970'

CALLBACK_URL = "http://thestationapp-c9-thestationapp.c9.io/auth/facebook/callback"

#@graph = Koala::Facebook::API.new("CAACEdEose0cBAGwNZBTXmmYRiMxrtwJnqUPBAJYgJbl8oBVf3CbdnDxzI54uN6We1qF3OeOhh0zWzGhAAYYyOT3elFWZB1gbLkk964ufJQkk9kIDkYtKHAPo6ewjT74WWqP05DrAeFxVIoSDpRQfqe8ZCTHHufAuGfQqxsx5ZCCCOKONriaksWK8dSrpRXzyYU2XJp8YujtOY1iX13qQ")
#@graph.fql_query("SELECT post_id, actor_id, target_id, message FROM stream WHERE source_id = me() AND created_time > START_TIME AND created_time < END_TIME LIMIT 10")



get '/auth/facebook' do
    
    @oauth = Koala::Facebook::OAuth.new(APP_ID, APP_SECRET, CALLBACK_URL)
    redirect @oauth.url_for_oauth_code
end

get '/auth/facebook/callback' do
    @oauth = Koala::Facebook::OAuth.new(APP_ID, APP_SECRET, CALLBACK_URL)
    response = @oauth.get_access_token(params[:code])

 
    addFacebook = Parse::Object.new("Facebook")
    addFacebook["username"] = session[:user]
    addFacebook["facebook_token"] = response
    addFacebook.save
  
  redirect to "/"
end