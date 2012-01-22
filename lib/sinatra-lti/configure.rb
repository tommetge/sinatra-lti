require 'yaml'

module Sinatra
  module SinatraLti
    def lti_default
      {
        :lti_title                => "Example Tool",
        :lti_description          => "Example LTI-enabled tool",
        :lti_extensions_platform  => "canvas.instructure.com",
        :lti_privacy_level        => "name_only",
        :lti_domain               => "example.com",
        :lti_launch_url           => "http://example.com/launch",
        :lti_bundle_identifier    => "BLTI001_Bundle",
        :lti_bundle_icon          => "BLTI001_Icon",
        :lti_options              => {
          :resource_selection => {
            :url => "http://example.com/launch"
          }
        }
      }
    end

    def lti_option(app, key)
      @lti_config ||= YAML::load_file(app.settings.lti_config) rescue nil
      if @lti_config && @lti_config[key]
        return @lti_config[key]
      else
        return lti_default[key]
      end
    end

    def self.registered(app)
      # this is the auto-configuration URL that can tell the LMS
      # how to use this tool.
      app.get '/configure' do
        options_xml = ""
        if options = lti_option(app, :lti_options)
          options.keys.each do |option_key|
            option_config = options[option_key]
            options_xml = %{<lticm:options name="#{option_key}">\n}
            option_config.keys.each do |option|
              options_xml << %{                  <lticm:property name="#{option}">#{option_config[option]}</lticm:property>\n}
            end
            options_xml << %{                </lticm:options>\n}
          end
        end
        %{
          <?xml version="1.0" encoding="UTF-8"?>
          <cartridge_basiclti_link xmlns="http://www.imsglobal.org/xsd/imslticc_v1p0"
              xmlns:blti = "http://www.imsglobal.org/xsd/imsbasiclti_v1p0"
              xmlns:lticm ="http://www.imsglobal.org/xsd/imslticm_v1p0"
              xmlns:lticp ="http://www.imsglobal.org/xsd/imslticp_v1p0"
              xmlns:xsi = "http://www.w3.org/2001/XMLSchema-instance"
              xsi:schemaLocation = "http://www.imsglobal.org/xsd/imslticc_v1p0 http://www.imsglobal.org/xsd/lti/ltiv1p0/imslticc_v1p0.xsd
              http://www.imsglobal.org/xsd/imsbasiclti_v1p0 http://www.imsglobal.org/xsd/lti/ltiv1p0/imsbasiclti_v1p0.xsd
              http://www.imsglobal.org/xsd/imslticm_v1p0 http://www.imsglobal.org/xsd/lti/ltiv1p0/imslticm_v1p0.xsd
              http://www.imsglobal.org/xsd/imslticp_v1p0 http://www.imsglobal.org/xsd/lti/ltiv1p0/imslticp_v1p0.xsd">
              <blti:title>#{lti_option(app, :lti_title)}</blti:title>
              <blti:description>#{lti_option(app, :lti_description)}</blti:description>
              <blti:launch_url>#{lti_option(app, :lti_launch_url)}</blti:launch_url>
              <blti:extensions platform="#{lti_option(app, :lti_extensions_platform)}">
                <lticm:property name="privacy_level">#{lti_option(app, :lti_privacy_level)}</lticm:property>
                #{options_xml}
              </blti:extensions>
              <cartridge_bundle identifierref="#{lti_option(app, :lti_bundle_identifier)}"/>
              <cartridge_icon identifierref="#{lti_option(app, :lti_bundle_icon)}"/>
          </cartridge_basiclti_link>
        }
      end
    end
  end
  register SinatraLti
end