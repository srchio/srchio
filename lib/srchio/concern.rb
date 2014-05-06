require 'active_support'

module Srchio
	module Concern
		extend ActiveSupport::Concern
		
		included do 
		
=begin rdoc
srch_save: Sends the document to your searcher. Could be used as an after_filter or in a job.
=end			
			def srch_save
				doc = {
					:body => srch_send(:body),
					:title => srch_send(:title),
					:url => srch_send(:url),
					:remote_id => srch_send(:remote_id)
				}
				
				if self.class.srch_config.keys.include?(:tags)
					doc[:tags] = srch_send(:tags)
				end
				
				if self.class.srch_config.keys.include?(:created)
					doc[:created] = srch_send(:created)
				end
				
				self.class.srch_add(doc)
			end
			
=begin rdoc
srch_destroy: Deletes the document from your searcher. Best used in an after_filter.
=end			
			def srch_destroy
				self.class.srch_destroy(:remote_id => srch_send(:remote_id))
			end

			def srch_send(key)
				self.send(self.class.srch_config[key])
			end
			
		end
		
		module ClassMethods
			
=begin rdoc
configure_srch: Configure the client for this model, mapping fields and setting the searcher id to use for all API call.

options:
* searcher_id: the id for the searcher to use. This should probably be set in an environment variable, so you don't accidentally use development data in your production searcher, for example.
* title: The method to use as the title when saving a document.
* body: The method to use as the body when saving a document.
* url: The method to use for the URL when saving a document.
* tags: The method to use for tags when saving a document.
* created: The method to use for setting the timestamp on a document.
* remote_id: The method to use for setting the id on a document (probably should be <code>:id</code>.
=end
			def configure_srch(opts={})
				raise "SearcherIdRequired" if opts[:searcher_id].nil?
				raise "TitleRequired" if opts[:title].nil?
				raise "BodyRequired" if opts[:body].nil?
				raise "UrlRequired" if opts[:url].nil?
				raise "RemoteIdRequired" if opts[:remote_id].nil?
				
				@@srch_config = opts
			end

			def srch_config
				@@srch_config
			end

			def srch_config=(opts)
				@@srch_config = opts
			end

=begin rdoc
srch_client: The client used to do all the API calls.  The concern provides method wrappers for everything, so you probably don't need to call this directly.
=end			
			def srch_client
				@@client ||= Srchio::Client.new(:searcher_id => srch_config[:searcher_id])
			end

=begin rdoc
srch: Search your content!

options:

* query: Query all the fields.
* page: The page of results to return, defaults to 1.
* per_page: The number of results to return per page.  Defaults to 25, max of 100.
* body: Search just the body for something.
* title: Search just the title for something.
* tags: Find documents by their tags.
* remote_id: Find a single document by the remote_id.
=end			
			def srch(opts={})
				srch_client.search(opts)
			end

=begin rdoc
tag_cloud: Return the tags for your searcher.

options:
* n: The number of tags to return.  Defaults to 1,000.
=end
      def tag_cloud(opts={})
        srch_client.tag_cloud(opts)
      end
      
=begin rdoc
srch_destroy: Destroy a document.

options: (one of them is required)

* remote_id: The id in your system for the document.
* index_id: The id for the document in our system.
=end
			def srch_destroy(opts={})
				srch_client.destroy_document(opts)
			end

=begin rdoc
srch_add: Add a document to your searcher.

options:

* title: *required*
* body: *required*
* url: *required*
* remote_id: *recommended* The id in your system for the object being added. 
* tags: An array or comma-separated list of tags.
* created: The creation timestamp for your document.
=end			
			def srch_add(opts={})
				srch_client.add_document(opts)
			end
			
		end
		
	end
end