require_relative 'spec_helper'

RSpec::Matchers.define :contain_repository_named do |repo_name|
  match do |actual|
    !actual.select { |repo| repo.name.eql?(repo_name) }.empty?
  end

  failure_message do |actual|
    "#{actual} did not contain a repository named #{repo_name}"
  end
end

describe TowerWorkflow::Folder do
  context 'with nested folders' do
    before(:all) do
      @top_level = TowerWorkflow::Folder.new
      @top_level << TowerWorkflow::Repository.new('Folder Depth 0, Repo 1', nil)

      folder_one = TowerWorkflow::Folder.new
      folder_one << TowerWorkflow::Repository.new('Folder Depth 1, Repo 1', nil)
      folder_one << TowerWorkflow::Repository.new('Folder Depth 1, Repo 2', nil)

      folder_two = TowerWorkflow::Folder.new
      folder_two << TowerWorkflow::Repository.new('Folder Depth 2, Repo 1', nil)
      folder_one << folder_two

      @top_level << folder_one
    end

    it '#all_repositories should return all repositories' do
      repos = @top_level.all_repositories
      expect(repos.size).to eq(4)
      expect(repos).to contain_repository_named('Folder Depth 0, Repo 1')
      expect(repos).to contain_repository_named('Folder Depth 1, Repo 1')
      expect(repos).to contain_repository_named('Folder Depth 1, Repo 2')
      expect(repos).to contain_repository_named('Folder Depth 2, Repo 1')
    end
  end
end