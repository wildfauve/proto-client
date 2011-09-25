require 'rest-client'
require 'json'

module MemberResource

  class ResourceConnection

    attr_accessor :host, :resource_entry, :format

    def self.configure(&block)
      rc = ResourceConnection.new
      rc.instance_eval &block
      raise ArgumentError, "Missing Configuration" if rc.host.nil? || rc.resource_entry.nil? || rc.format.nil?
      raise ArgumentError, "Format Error" if rc.format != :json
      return rc
    end
  
    def create_resource(member)
      url = "#{host}#{resource_entry}"
      puts "#{url} #{member.inspect}"
      body = member.send @format
      puts body
      @last_resp = RestClient.post(url, body, :content_type => @format, :accept => @format)
      if @format == :json
        puts JSON::parse @last_resp
      end
    end

  end

  class Member

    attr_accessor :name, :card_num
    
    def self.create(connection, &block)
      @@connection = connection
      class_eval &block
    end
    
    def self.member(&block)
      puts "in member class"
      m = Member.new
      m.instance_eval &block
      m.create(@@connection)
    end
    
    def create(connection)
      connection.create_resource(self)
    end
      
    def json
      thash = {:name => @name, :card_num => @card_num }.to_json
      return thash
    end
    
    def to_hash
      thash = {:name => @name, :card_num => @card_num }
      puts thash
      return thash
    end
  
  end

end
