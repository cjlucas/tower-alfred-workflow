require 'rubygems'
require 'bundler'
Bundler.setup(:default, :test)

require 'rspec'
require 'coveralls'

require 'alfredlite'
require 'alfredlite/feedback'

Coveralls.wear!
