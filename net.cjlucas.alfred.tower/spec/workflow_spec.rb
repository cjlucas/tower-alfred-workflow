require_relative 'spec_helper'

describe TowerWorkflow::Workflow do
  before(:each) do
    # simulate #all_repositories
    repos = []
    repos << TowerWorkflow::Repository.new('ruby1', nil)
    repos << TowerWorkflow::Repository.new('ruby2', nil)
    repos << TowerWorkflow::Repository.new('ruby3', nil)
    repos << TowerWorkflow::Repository.new('python1', nil)
    repos << TowerWorkflow::Repository.new('python2', nil)

    @workflow = TowerWorkflow::Workflow.new('.')
    @workflow.instance_variable_set(:@repositories, repos)
  end

  context 'when query is nil' do
    it 'should return all repositories' do
      repos = @workflow.find_repos(nil)
      expect(repos).to contain_repository_named('ruby1')
      expect(repos).to contain_repository_named('ruby2')
      expect(repos).to contain_repository_named('ruby3')
      expect(repos).to contain_repository_named('python1')
      expect(repos).to contain_repository_named('python2')
    end
  end

  context 'when query is an empty string' do
    it 'should return all repositories' do
      repos = @workflow.find_repos('')
      expect(repos).to contain_repository_named('ruby1')
      expect(repos).to contain_repository_named('ruby2')
      expect(repos).to contain_repository_named('ruby3')
      expect(repos).to contain_repository_named('python1')
      expect(repos).to contain_repository_named('python2')
    end
  end

  context 'when query is valid' do
    it 'should only return repositories that match the query' do
      repos = @workflow.find_repos('ruby')
      expect(repos.size).to eq(3)
      expect(repos).to contain_repository_named('ruby1')
      expect(repos).to contain_repository_named('ruby2')
      expect(repos).to contain_repository_named('ruby3')
    end
  end
end