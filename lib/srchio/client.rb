module Srchio
  class Client
    include HTTParty

    attr_accessor :searcher_id, :api_token, :api_domain, :api_protocol

    base_uri "https://srch.io/"

    def self.api_protocol
      @@api_protocol ||= "https"
    end

    def self.api_protocol=(p)
      @@api_protocol = p
      update_base_uri
    end

    def self.api_domain
      @@api_domain ||= "srch.io"
    end

    def self.api_domain=(domain)
      @@api_domain = domain
      update_base_uri
    end

    def self.api_token
      @@api_token || nil
    end

    def self.api_token=(token)
      @@api_token = token
      update_default_headers
      true
    end

    def self.searcher_id
      @@searcher_id || nil
    end

    def self.searcher_id=(id)
      @@searcher_id = id
      true
    end

    def self.update_base_uri
      base_uri "#{self.api_protocol}://#{self.api_domain}/"
      true
    end

    def self.update_default_headers
      headers 'X_SRCH_API_TOKEN' => self.api_token
      true
    end

=begin rdoc
Create a new Srchio::Client. 
options:
* :searcher_id: The ID of the searcher to use for this client.
* :api_token: This is required if you haven't set it using Srch::Client.api_token=
* :api_protocol: optional - defaults to https
* :api_domain: optional - defaults to srch.io
=end
    def initialize(opts={})
      raise ArgumentError, "opts must be a Hash" unless opts.is_a?(Hash)
      
      @searcher_id = opts[:searcher_id] || @@searcher_id
      
      raise ArgumentError, ":searcher_id must not be nil" if @searcher_id.nil?
    end

=begin rdoc
Sends a test request, making sure you're sending the api token correctly
=end
    def test
      Srchio::Response.new(self.class.get("/api/test"))
    end

=begin rdoc
Add or update a document in the searcher.
options:
* :url: required, the URL for the document
* :title: required, the title of the document
* :body: required, the body of the document
* :tags: optional, the list of tags for the document.
* :remote_id: optional, but recommended, the id of the document in your system.
* :created: optional - the timestamp for the record.
=end
    def add_document(opts={})
      raise ArgumentError, ":title is required" if opts[:title].nil?
      raise ArgumentError, ":body is required" if opts[:body].nil?
      raise ArgumentError, ":url is required" if opts[:url].nil?
      
      if opts[:tags].is_a?(Array)
        opts[:tags] = opts[:tags].join(",")
      end
      
      Srchio::Response.new(self.class.post("/api/searchers/#{searcher_id}/documents", :query => opts))
    end

=begin rdoc
Delete a document from the searcher.
options: One of the following is required.
* :remote_id: The remote_id you set when adding the document.
* :index_id: The id returned by the system when you added the document
=end
    def destroy_document(opts={})
      raise ArgumentError if opts[:remote_id].nil? && opts[:index_id].nil?
      
      Srchio::Response.new(self.class.delete("/api/searchers/#{searcher_id}/documents", :query => opts))
    end

=begin rdoc
Searches your searcher!
options:
* :query: A text string to search for.  Searches title, body and tags for this string.
* :body: A query, searches just the body.
* :title: A query, searches just the title.
* :tags: An array of tags to search for.
* :remote_id: A remote_id to search for.
* :id: The id of the document you wish to retrieve.
* :page: The page of results to return.  Defaults to 1.
* :per_page: How many results to return per page.  Defaults to 25.
=end
    def search(opts={})
      if opts[:query].nil? && opts[:body].nil? && opts[:title].nil? && opts[:tags].nil? && opts[:remote_id].nil? && opts[:id].nil?
        raise ArgumentError, "Opts must contain at least one of: :query, :body, :title, :tags, :remote_id, :id"
      end
      
      if opts[:tags].is_a?(Array)
        opts[:tags] = opts[:tags].join(",")
      end
      
      Srchio::Response.new(self.class.get("/api/searchers/#{searcher_id}/search", :query => opts))
    end
 
=begin rdoc
Returns the tag cloud for your searcher. It will only return the number of unique tags you have that appear in at least one document.
options:
* :n: The number of tags to return.  Defaults to 1,000.  
=end    
    def tag_cloud(opts={})
      Srchio::Response.new(self.class.get("/api/searchers/#{searcher_id}/tag_cloud", :query => opts))
    end
  end
end