require 'oauth'
require 'oauth/request_proxy/rack_request'

module Sinatra
  module SinatraLti

    def self.registered(app)
      # this is the entry action that the LTI Tool Consumer sends the
      # browser to when launching the tool.
      app.post '/launch' do
        # first we have to verify the oauth signature, to make sure this isn't
        # an attempt to hack the planet
        begin
          signature = OAuth::Signature.build(request, :consumer_secret => app.settings.oauth_secret)
          signature.verify() or raise OAuth::Unauthorized
        rescue OAuth::Signature::UnknownSignatureMethod,
               OAuth::Unauthorized
          return %{unauthorized attempt. make sure you used the consumer secret "#{$oauth_secret}"}
        end

        # store the relevant parameters from the launch into the user's session, for
        # access during subsequent http requests.
        # note that the name and email might be blank, if the tool wasn't configured
        # in Canvas to provide that private information.
        [
          'resource_link_id', 
          'resource_link_title', 
          'resource_link_description', 
          'user_id', 
          'roles', 
          'lis_person_name_full', 
          'lis_person_name_family', 
          'lis_person_name_given', 
          'lis_person_contact_email_primary', 
          'lis_person_sourcedid', 
          'context_id', 
          'context_title', 
          'context_label', 
          'tool_consumer_info_product_family_code', 
          'tool_consumer_info_version', 
          'tool_consumer_instance_guid', 
          'tool_consumer_instance_description'
        ].each { |v| session[v] = params[v] }

        # that's it, setup is done. now send them to the assessment!
        redirect to("/")
      end

      # any request without an LTI signature will be redirected here
      app.get '/lti_required' do
        return %{This service requires LTI.}
      end
    end
  end
  register SinatraLti
end