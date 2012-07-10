require 'grape'

require 'multi_json'
require 'securerandom'


module Grape
  module Apidoc
    class Browser
      
      def self.setup(builder, opts = {})
        
        url = opts.delete(:url) || 'http://localhost:3000/'
        root_path = opts.delete(:root_path) || 'browser'
        
        builder.instance_eval do
          map(root_path) { run Rack::File.new(File.expand_path('../../../vendor/swagger', __FILE__)) }
          map(File.join(root_path, 'doc')) do
            app = Grape::Apidoc::Browser.new(:server_url => 'http://localhost:3000/', :root_path => root_path) do |g|
              yield(g)
            end

            run app
          end
          
        end
      end
    
      SWAGGER_VERSION = "1.0".freeze
    
      def initialize(opts = {})
        @api_version = opts.delete(:api_version) || '1.0'
        @server_url = opts.delete(:server_url)
        @root_path= opts.delete(:root_path)
        
        
        @apis = {}
        @apis_list = {}
      
        @api_description = {}
      
        yield(self) if block_given?
        rebuild()
      end
    
      def add_grape_api(path, api)      
        merged_path = File.join(@root_path, 'doc', path)
        @apis[merged_path] = api
        @api_description[merged_path] = api_doc(path, api)
      end
    
      def call(env)      
        ret = ""
        path = env['REQUEST_PATH']
        
        if @api_description[path]
          ret = MultiJson.dump(@api_description[path])
        else
          ret = MultiJson.dump(@list)
        end
        
        [200, {}, [ret]]
      end
    
  
  
    private
      def rebuild
        # short list
        @list = apis_list()
        @apis = nil
      end
    
      def api_header(resource_path = nil)
        ret = {
          "apiVersion"      => @api_version.to_s,
          "swaggerVersion"  => SWAGGER_VERSION,
          "basePath"        => @server_url
        }
      
        if resource_path
          ret["resourcePath"] = resource_path
        end
      
        ret
      end
    
    
      # api list
      def apis_list
        {
          "apis"            => @apis.map{|path ,api| api_short_description(path, api) },
          "models"          => {
            "car" => {"properties" => {"title" => { "type" => "string"}}}
          }
        }.merge(api_header())
      end  
    
      def api_short_description(path, api)
        {
          "path"        => path[1..-1],
          "description" => "Grape API"
        }
      end
    
    
      # full doc
      def api_doc(path, api)
        {
          "apis"            => api_long_description(path, api)
        }.merge(api_header(path))
      end
    
      def api_long_description(base_path, api)
        ret = []
        
        api.endpoints.each do |endpoint|
          ret << {
            "path"          => _convert_path(File.join(base_path, endpoint.options[:path].first)),
            "description"   => endpoint.options[:route_options][:description],
            "operations"    => [operation_descr(endpoint)]
          }
        end
        
        ret
      end
    
      # :x => {x}
      def _convert_path(path)
        path.gsub(/:([a-z]+)/, '{\1}')
      end
    
    
    
      def operation_descr(endpoint)
        ret = {
          "httpMethod"            => endpoint.options[:method].first,
          "notes"                 => endpoint.options[:route_options][:notes],
          "parameters"            => [],
          "nickname"              => SecureRandom.hex(4),
          "summary"               => endpoint.options[:route_options][:description]
        }
      
        if endpoint.options[:route_options][:params]
          endpoint.options[:route_options][:params].each do |param_name, param_options|
            ret["parameters"] << {
              "name"          => param_name,
              "description"   => param_options[:desc],
              "dataType"      => param_options[:type],
              "required"      => param_options[:required] == true,
              "paramType"     => "query"
            }
          end
        end
      
        ret
      end

    end
  end
end

