require_relative '../bundle/bundler/setup'
require 'rspec'

require_relative '../lib/tower_workflow'

def data_file(filename)
  File.join(File.dirname(__FILE__), 'files', filename)
end