require 'rest-client'
require 'json'

module MemberResource

  class ResourceConnection
    
    @@token = "admin"

    attr_accessor :host, :resource_entry, :format

    def self.configure(&block)
      rc = ResourceConnection.new
      rc.instance_eval &block
      raise ArgumentError, "Missing Configuration" if rc.host.nil? || rc.resource_entry.nil? || rc.format.nil?
      raise ArgumentError, "Format Error" if rc.format != :json
      return rc
    end
  
    def create_resource(represent)
      url = "#{host}#{resource_entry}"
      body = represent.send @format
      puts "Resource Create: #{url}, #{body}"
      begin
        last_resp = RestClient.post(url, body, :content_type => @format, :accept => @format, :params => {:token => @@token})
        if @format == :json
          puts "Status Code: #{last_resp.code}  Headers: #{last_resp.headers[:location]}"
          puts "Response Body: #{JSON::parse last_resp}"
        end
      rescue => e
        puts "Server Exception Occured: #{e.response.code}"
      end
    end

  end

  class Member
    
    @@template = {:name => String, 
                  :card_num => String} 
    
    def self.create(connection, &block)
      @@connection = connection
      class_eval &block
    end
    
    def self.member(&block)
      m = Member.new
      m.instance_eval &block
      m.create(@@connection)
    end
        
    def initialize
      @represent = {}
    end
    
    def create(connection)
      connection.create_resource(self)
    end
    
    def add_prop(arg)
      arg.each do |k, v|
        if @@template.has_key?(k) && v.class == @@template[k]
          @represent[k] = v
        else
          raise ArgumentError, "Invalid property #{k}"
        end
      end
    end
      
    def json
      return @represent.to_json
    end
  
  end

end
