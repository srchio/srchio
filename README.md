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

If you have any issues, please create a [Github Issue](https://github.com/railsmachine/srchio/issues).  Thanks for using srch.io!