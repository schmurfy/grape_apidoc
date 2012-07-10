
require 'rubygems'
require 'bundler/setup'

require 'grape'
require 'grape/apidoc'

class TestAPI < Grape::API
  default_format :json
  
  desc "say hello"
  params do
    requires :name,     type: String,   desc: "Your name"
    optional :a_number, type: Integer,  desc: "A number"
  end
  get do
    {:message => "Hello #{params[:name]}"}
  end
  
  desc "a + b", :notes => "Some notes"
  params do
    requires :a, :b, type: Integer, desc: "numbers"
  end
  get '/add' do
    params[:a] + params[:b]
  end
  
  desc "Coerce"
  params do
    optional :arr, coerce: Array[Integer]
  end
  get '/coerce' do
    params[:arr].inject(&:+)
  end
  
end

use Rack::CommonLogger

Grape::Apidoc::Browser.setup(self, :root_path => '/browser') do |g|
  g.add_grape_api('/api', TestAPI)
end

map '/api' do
  run TestAPI
end

