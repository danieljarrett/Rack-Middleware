Rack-Middleware
============

A minimal app to illustrate the usage and testing of middleware.

### Application Layers

* Basic Rack App
* Quote Retriever
* Quick Formatter

##### Basic Rack App

When a request is made at any URI other than `/quote`, the response is as follows.  Passing parameters along with the request (`GET`/`POST`) does not affect the response.

	Request: /<any path>

	Response: 'Just some regular text here.'

	Format: text/plain

##### Quote Retriever

This is a piece of middleware.  When a request is made at `/quote`, the response is as follows.  Passing parameters of the form `{ 'term' => <keyword> }` along with a request (`GET`/`POST`) narrows down the possibilities of the random quote returned, through substring matching.  If no matches are found, a message is displayed instead of the quote: 'No quotes found. Try again!'

	Request: /quote

	Response: <random quote>

	Format: text/plain

##### Quick Formatter

As an exercise to illustrate the ordering of middleware and how different layers stack, this is another piece that wraps a simple html frame around the response, if the original response is `text/plain`.  This can be turned off in `config.ru` by removing the `true` argument on the `use QuickFormatter` line.

	Request: /<any path>

	Response: html page

	Format: text/html

### Testing

RSpec tests are written for the QuoteRetriever middleware.  Tests for `POST` requests are also written, and are virtually identical to the tests for `GET` requests. These can all be run by executing the following command:

	$ rspec spec

### Resources

* [Rack Wiki](https://github.com/rack/rack/wiki)
* [Ruby on Rack](http://meaganwaller.com/ruby-on-rack/)
* [Rack Middleware](http://www.integralist.co.uk/posts/rack-middleware.html)
* [Middleware Examples](http://karmi.tumblr.com/post/663716963/rack-middleware-examples)
* [Testing Middleware #1](http://shift.mirego.com/post/68808986788/how-to-write-tests-for-rack-middleware)
* [Testing Middleware #2](http://stackoverflow.com/questions/17506567/testing-middleware-with-rspec)