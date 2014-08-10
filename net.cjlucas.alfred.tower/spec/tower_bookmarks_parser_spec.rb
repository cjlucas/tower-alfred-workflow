require_relative 'spec_helper'

class TowerWorkflow::Folder
  def folders_named(folder_name)
    sub_folders.select { |folder| folder.name.eql?(folder_name) }
  end

  def repositories_named(repository_name)
    repositories.select { |repo| repo.name.eql?(repository_name) }
  end
end

describe TowerWorkflow::BookmarksParser do
  context 'with a single empty folder' do
    before(:all) do
      bookmarks_file = data_file('bookmarks_empty_folder.xml')
      @bookmarks = described_class.get_bookmarks(bookmarks_file)
      @empty_folder = @bookmarks.folders_named('Empty Folder').first
    end

    it 'should contain one folder' do
      expect(@empty_folder).not_to be_nil
    end

    it 'should contain zero repositories' do
      expect(@bookmarks.repositories).to be_empty
      expect(@empty_folder.repositories).to be_empty
    end

    it 'should contain zero sub folders' do
      expect(@empty_folder.sub_folders).to be_empty
    end
  end

  context 'with multiple folders (one level deep)' do
    before(:all) do
      bookmarks_file = data_file('bookmarks_multiple_folders.xml')
      @bookmarks = described_class.get_bookmarks(bookmarks_file)
    end

    it 'should contain all folders' do
      expect(@bookmarks.folders_named('Folder 1').size).to eq(1)
      expect(@bookmarks.folders_named('Folder 2').size).to eq(1)
    end

    it 'should contain all repositories' do
      expect(@bookmarks.has_repository?('Default Folder, Repo 1')).to be_truthy

      folder = @bookmarks.folders_named('Folder 1').first
      expect(folder.has_repository?('Folder 1, Repo 1')).to be_truthy
      expect(folder.has_repository?('Folder 1, Repo 2')).to be_truthy
      expect(folder.has_repository?('Folder 1, Repo 3')).to be_truthy

      folder = @bookmarks.folders_named('Folder 2').first
      expect(folder.has_repository?('Folder 2, Repo 1')).to be_truthy
      expect(folder.has_repository?('Folder 2, Repo 2')).to be_truthy
    end
  end
end