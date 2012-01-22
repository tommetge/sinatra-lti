require 'bundler/setup'
require 'sinatra/base'
require 'json'

module Sinatra
  module SinatraLti
   def self.registered(app)
     app.before /^(?!\/(launch|lti_required|configure))/ do
       require_lti!
     end

     app.get '/test' do
       session.to_json
     end
   end
  end
  register SinatraLti
end