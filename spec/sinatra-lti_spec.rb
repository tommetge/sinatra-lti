require 'sinatra-lti'
require 'spec'
require 'rack/test'

describe SinatraLti, "#helpers" do
  include Rack::Test::Methods
  def app; Sinatra::Application; end

  it "should require lti parameters for protected resources" do
    get '/test', {}, 'rack.session' => { 'resource_link_id' => 'testresourceid' }
    last_response.should be_ok
  end
  
  it "should allow lti-enabled requests for protected resources" do
    get '/test'
    last_response.status.should == 302
    URI.parse(last_response.header["Location"]).path.should == "/lti_required"
  end

  it "should allow access to lti-provided resources via session store" do
    include Sinatra::SinatraLti::Helpers
    session = {
      'resource_link_id' => 'testresourceid',
      'lis_person_name_full' => 'Name'
    }
    get '/test', {}, 'rack.session' => session
    last_response.should be_ok
    JSON.parse(last_response.body)['lis_person_name_full'].should == 'Name'
  end
end

describe SinatraLti, "#launch" do
  include Rack::Test::Methods
  def app; Sinatra::Application; end

  it "should appropriately message non-launch URLs" do
    get '/lti_required'
    last_response.should be_ok
    last_response.body.should == "This service requires LTI."
  end

  it "should require a POST to launch" do
    get '/launch'
    last_response.status.should == 404
  end

  it "should populate session with lti parameters on launch" do
    
  end
end

describe SinatraLti, "#configure" do
  include Rack::Test::Methods
  def app; Sinatra::Application; end

  it "should use appropriate defaults when options are not configured" do
    get '/configure'
    puts last_response.body
    last_response.status.should == 200
    # TODO: test the returned XML
  end

  it "should use provided options for configuration XML" do
    # TODO: test configuration
  end
end