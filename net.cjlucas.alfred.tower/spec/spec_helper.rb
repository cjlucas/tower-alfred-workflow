require_relative '../bundle/bundler/setup'
require 'rspec'

require_relative '../lib/tower_workflow'

def data_file(filename)
  File.join(File.dirname(__FILE__), 'files', filename)
end

RSpec::Matchers.define :contain_repository_named do |repo_name|
  match do |actual|
    !actual.select { |repo| repo.name.eql?(repo_name) }.empty?
  end

  failure_message do |actual|
    "#{actual} did not contain a repository named #{repo_name}"
  end
end
