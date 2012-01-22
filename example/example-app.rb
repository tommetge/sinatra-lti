require 'rubygems'
require 'sinatra'
require 'sinatra-lti'

configure do
  # the config file isn't strictly required - defaults are provided.
  # that said, your lti service will do little more than welcome you
  # if you do not provide a configuration.
  set :lti_config, Pathname(__FILE__).dirname.join('lti_config.yml')

  # oauth is required. this is the "secret" value you will use when
  # configuring your LMS.
  set :oauth_secret, "secret"

  # sinatra wants to set x-frame-options by default, disable it
  disable :protection

  # enable sessions so we can remember the launch info between http requests, as
  # the user interacts with your LTI service or tool
  enable :sessions
end

# by default, the LMS will be redirected to '/' after a successful
# LTI launch. this is where you will want to put your app home.
get '/' do
  "Welcome " + username + "! It worked!"
end
