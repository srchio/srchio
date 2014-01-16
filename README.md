## Introduction

This is the ruby wrapper for [srch.io](http://srch.io).  We're a platform as a service providing an easy developer-friendly way to add search to your application or site!

## Setup 

Add the gem to your Gemfile:

<pre><code>gem 'srchio'</code></pre>

Run <code>bundle install</code>.

Log in to your account on [srch.io](http://srch.io) and create a new Searcher.  You'll need two pieces of information to use the gem: your api token, and the id of your searcher.  You can get your API Token on your [Account page](https://srch.io/account), and the ID of your searcher from that searcher's page, linked from [Your Searchers](https://srch.io/searchers).

If you're using it in Rails, you'll probably want to create an initializer that looks something like this:

<pre><code>require 'srchio'
Srchio::Client.api_token = ENV['SRCH_API_TOKEN']
Srchio::Client.searcher_id = ENV['SRCH_ID']</code></pre>

## Usage

Once you've configured things, you'll want to use it!

<pre><code>client = Srchio::Client.new

client.add_document(
  url: "http://srch.io",
  title: "srch.io - home",
  body: "srch.io is a fun way to add search to your app.",
  remote_id: 1,
  tags: ['fun', 'api', 'awesome']
)

client.search(query: "fun")</code></pre>

If you need to delete a document, you can do it either with your remote_id or the index_id returned in the add_document call:

<pre><code>client.destroy_document(remote_id: 1)</code></pre>

## Using The ActiveSupport::Concern

Since we're so nice, we went ahead and created a handy ActiveSupport::Concern to include in your models to get all the srch.io goodness right in your model and the make wiring things up faster.  Here's how you'd use it in a standard ActiveRecord model:

<pre><code>class Foo < ActiveRecord::Base
	# Tell srchio where to get the fields to index (these are the methods on your model that provide those values, like foo.id):
	
	configure_srch searcher_id: 1,
		title: :foo_title,
		body: :text,
		remote_id: :id,
		created: :created_at, 
		url: :url_generator
		
	after_save :srch_save
	after_destroy :srch_destroy
end</code></pre>

If you're adding search to an existing model, you'll probably want to do something like the following to get all of your documents indexed:

<pre><code>Foo.find_each do |foo|
	foo.srch_save
end</code></pre>

And to search for documents:

<pre><code>results = Foo.srch(query: "Bob", page: 1, per_page: 25)</code></pre>

And that's pretty much it!

If you're like me and don't like waiting around for anything, you could do something like the following to push indexing and destroying records into your [Sidekiq](http://sidekiq.org) queue:

<pre><code>class FooIndexWorker
	include Sidekiq::Worker
	
	def perform(id)
		Foo.find(id).srch_save
	end
end</code></pre>

And to destroy the document:

<pre><code>class FooDestroyWorker
	include Sidekiq::Worker
	
	def perform(id)
		Foo.srch_destroy(remote_id: id)
	end
end</code></pre>

Then you'd just change your before and after filters to shove things into the queue instead of doing it right there.  Adding and deleting documents is fast, but we like keeping things as async as possible to make the experience for your users better.
## Help!

If you have any issues, please create a [Github Issue](https://github.com/railsmachine/srchio/issues).  Thanks for using srch.io!