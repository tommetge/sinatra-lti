Sinatra LTI
===========

LTI (http://www.imsglobal.org/lti/) allows an LMS to make use of
the service(s) you provide. This gem makes it a little easier to
enable LTI in your service or application.

Usage
-----

Take a look at the example application (in the "examples"
directory of the gem's installation) to get the basic idea.

Simply require this gem (sinatra-lti) in your Sinatra-based
application. Doing so will add the following routes:

/config
/launch
/lti_required

The '/config' route can be used to provide an XML file to
configure the LMS to use your service. The document is produced
in accordance with the configuration you provide via a simple
YAML file. You will need to notify the Sinatra-LTI of your YAML
configuration. To do so, use Sinatra's configuration and:

set :lti_config, Pathname(__FILE__).dirname.join('lti_config.yml')

An example configuration file is available in the "example"
directory of the gem's installation.

The '/launch' route is the entry point for the LMS and is where
OAuth2 is validated and identity information is exchanged. If
you must manually configure your LMS, this is the URL to which
it should land first.

One note: as you create your application, you will also need to
provide a '/' route in your Sinatra app. After a successful
"launch" from the LMS, Sinatra-LTI will redirect to '/' with
the expectation that this route will be the user's entry point
to your service's functionality.

Notes
-----

More documentation will be forthcoming. This set is intended
to be just enough for you to puzzle out the rest. More robust
and friendly docs are in the works.
