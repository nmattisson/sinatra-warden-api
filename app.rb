require 'sinatra/base'
require 'sinatra/json'
require 'warden'

class SinatraWardenAPI < Sinatra::Base

# This is the Hello World route (so that you can see that the code is running).
get '/' do
    content_type :json
    json({ message: "Hello World" })
end

# This is the protected route, without the proper access token you'll be redirected.
get '/protected' do
    env['warden'].authenticate!(:access_token)
    
    content_type :json
    json({ message: "This is an authenticated request!" })
end

# This is the route that unauthorized requests gets redirected to.
post '/unauthenticated' do
    content_type :json
    json({ message: "Sorry, this request can not be authenticated. Try again." })
end
    
    
# Configure Warden
use Warden::Manager do |config|
    config.scope_defaults :default,
    # Set your authorization strategy
    strategies: [:access_token],
    # Route to redirect to when warden.authenticate! returns a false answer.
    action: '/unauthenticated'
    config.failure_app = self
end

Warden::Manager.before_failure do |env,opts|
    env['REQUEST_METHOD'] = 'POST'
end

# Implement your Warden stratagey to validate and authorize the access_token.
Warden::Strategies.add(:access_token) do
    def valid?
        # Validate that the access token is properly formatted.
        # Currently only checks that it's actually a string.
        request.env["HTTP_ACCESS_TOKEN"].is_a?(String)
    end

    def authenticate!
        # Authorize request if HTTP_ACCESS_TOKEN matches 'youhavenoprivacyandnosecrets'
        # Your actual access token should be generated using one of the several great libraries
        # for this purpose and stored in a database, this is just to show how Warden should be
        # set up.
        access_granted = (request.env["HTTP_ACCESS_TOKEN"] == 'youhavenoprivacyandnosecrets')
        !access_granted ? fail!("Could not log in") : success!(access_granted)
    end
end

end