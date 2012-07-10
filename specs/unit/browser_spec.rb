require_relative '../spec_helper'

describe "Autodoc" do

  before do
    @api = Class.new(Grape::API) do
      default_format :json
      
      desc "I do something !"
      params do
        requires :id, :regexp => /^[0-9]+$/
      end
      post do
        
      end
      
      desc "get something"
      get ':id' do
        
      end
      
    end
    
    app = Grape::Apidoc::Browser.new(:api_version => '0.2', :server_url => 'http://localhost:3000/', :root_path => '/browser') do |g|
      g.add_grape_api('/api', @api)
    end
    
    start_server(app)
  end
  
  def _common(ret)
    ret['apiVersion'].should == '0.2'
    ret['swaggerVersion'].should == '1.0'
    ret['basePath'].should == 'http://localhost:3000/'
  end
  
  it 'should return services list' do
    req = http_request(:get, '/')
    check_http_response_status(req, 200)
    ret = MultiJson.load(req.response)
    
    _common(ret)
    ret['apis'].size.should == 1
    ret['apis'][0].should == {"path"=>"browser/doc/api", "description"=>"Grape API"}
    
    ret.has_key?('resourcePath').should == false
  end
  
  it "should return service description" do
    req = http_request(:get, '/browser/doc/api')
    check_http_response_status(req, 200)
    ret = MultiJson.load(req.response)
    _common(ret)
    
    ret['apis'].size.should == 2
    ret['apis'][0].tap do |api|
      api['path'].should == '/api/'
      api['description'].should == 'I do something !'
      api['operations'].size.should == 1
      api['operations'][0].tap do |op|
        op['httpMethod'].should == 'POST'
        # op['notes'].should == ""
        # op['summary'].should == ""
        # op['nickname'].should == "getSomething"
      end
    end
    
    ret['apis'][1].tap do |api|
      api['path'].should == '/api/{id}'
      api['description'].should == 'get something'
      api['operations'].size.should == 1
      api['operations'][0].tap do |op|
        op['httpMethod'].should == 'GET'
      end
    end
    
    
    # {"apis"=>[{"path"=>["/"], "description"=>"I do something !", "operations"=>[{"httpMethod"=>["POST"], "notes"=>"Some notes", "responseTypeInternal"=>"Integer", "errorResponses"=>[{"reason"=>"Pet not found", "code"=>404}], "nickname"=>"getPetById", "responseClass"=>"pet", "summary"=>"Find pet by ID"}]}], }
  end
  
end
