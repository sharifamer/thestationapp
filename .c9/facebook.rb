require 'koala'
require 'oauth'
require 'facebook'
    @graph = Koala::Facebook::API.CAACEdEose0cBANDfVlDVIkgmQEWjhx1Ickpt9czHphDDOMRF9S88DZBtYCRaCdHiaZCX5oFAVCWEjMamkoLSbxDLwfGaY0903wWDPkYqGmX2n87OQPrf4IW0EXGsXA3e456tZCf0vgrWEBpGQGnIUrjPvoVlPrUfjlJOBKtc4D3yZAmpK1Xj2PqdlxGVjJClIaCmBAwYBAZDZD

profile = @graph.get_object("me")
friends = @graph.get_connections("me", "friends")
    @graph.put_connections("me", "feed", :message => "I am writing on my wall!")

# Three-part queries are easy too!
    @graph.get_connections("me", "mutualfriends/#{friend_id}")

# You can use the Timeline API:
# (see https://developers.facebook.com/docs/beta/opengraph/tutorial/)
    @graph.put_connections("me", "namespace:action", :object => object_url)

# For extra security (recommended), you can provide an appsecret parameter,
# tying your access tokens to your app secret. 
# (See https://developers.facebook.com/docs/reference/api/securing-graph-api/
# You'll need to turn on 'Require proof on all calls' in the advanced section
# of your app's settings when doing this.
    @graph = Koala::Facebook::API.new(oauth_access_token, app_secret)

# Facebook is now versioning their API. # If you don't specify a version, Facebook 
# will default to the oldest version your app is allowed to use. Note that apps 
# created after f8 2014 *cannot* use the v1.0 API. See 
# https://developers.facebook.com/docs/apps/versions for more information.
#
# You can specify version either globally:
Koala.config.api_version = "v2.0"
# or on a per-request basis
    @graph.get_object("me", {}, api_version: "v2.0")
    
# Returns the feed items for the currently logged-in user as a GraphCollection
feed = @graph.get_connections("me", "feed")
feed.each {|f| do_something_with_item(f) } # it's a subclass of Array
next_feed = feed.next_page

# You can also get an array describing the URL for the next page: [path, arguments]
# This is useful for storing page state across multiple browser requests
next_page_params = feed.next_page_params
page = @graph.get_page(next_page_params)

@graph.batch do |batch_api|
  batch_api.get_object('me')
  batch_api.put_wall_post('Making a post in a batch.')
end

@rest = Koala::Facebook::API.new(oauth_access_token)

@rest.fql_query(my_fql_query) # convenience method
@rest.fql_multiquery(fql_query_hash) # convenience method
@rest.rest_call("stream.publish", arguments_hash) # generic version

@api = Koala::Facebook::API.new(oauth_access_token)
fql = @api.fql_query(my_fql_query)
@api.put_wall_post(process_result(fql))

# config/initializers/koala.rb
require 'koala'

Koala.configure do |config|
  config.graph_server = 'my-graph-mock.mysite.com'
  # other common options are `rest_server` and `dialog_host`
  # see lib/koala/http_service.rb
end

@oauth = Koala::Facebook::OAuth.new(app_id, app_secret, callback_url)

# parses and returns a hash including the token and the user id
# NOTE: this method can only be called once per session, as the OAuth code
# Facebook supplies can only be redeemed once.  Your application must handle
# cross-request storage of this information; you can no longer call this method
# multiple times.
@oauth.get_user_info_from_cookies(cookies)

# generate authenticating URL
@oauth.url_for_oauth_code
# fetch the access token once you have the code
@oauth.get_access_token(code)

@oauth.get_app_access_token

@oauth.parse_signed_request(signed_request_string)

@oauth.get_token_from_session_key(session_key)
@oauth.get_tokens_from_session_keys(array_of_session_keys)

@updates = Koala::Facebook::RealtimeUpdates.new(:app_id => app_id, :secret => secret)

# Add/modify a subscription to updates for when the first_name or last_name fields of any of your users is changed
@updates.subscribe("user", "first_name, last_name", callback_url, verify_token)

# Get an array of your current subscriptions (one hash for each object you've subscribed to)
@updates.list_subscriptions

# Unsubscribe from updates for an object
@updates.unsubscribe("user")

# Returns the hub.challenge parameter in params if the verify token in params matches verify_token
Koala::Facebook::RealtimeUpdates.meet_challenge(params, your_verify_token)

@test_users = Koala::Facebook::TestUsers.new(:app_id => id, :secret => secret)
user = @test_users.create(is_app_installed, desired_permissions)
user_graph_api = Koala::Facebook::API.new(user["access_token"])
# or, if you want to make a whole community:
@test_users.create_network(network_size, is_app_installed, common_permissions)

# Set an SSL certificate to avoid Net::HTTP errors
Koala.http_service.http_options = {
  :ssl => { :ca_path => "/etc/ssl/certs" }
}
# or on a per-request basis
@api.get_object(id, args_hash, { :request => { :timeout => 10 } })

# From anywhere in the project directory:
bundle exec rake spec

# Again from anywhere in the project directory:
LIVE=true bundle exec rake spec
# you can also test against Facebook's beta tier
LIVE=true BETA=true bundle exec rake spec
