require_relative 'spec_helper'

describe TowerWorkflow::BookmarksParser do
  context 'with a single empty folder' do
    before(:each) do
      bookmarks_file = data_file('bookmarks_empty_folder.xml')
      @folders = described_class.get_folders(bookmarks_file)
    end

    it '#get_folders should return one empty Folder' do
      expect(@folders.size).to eq(1)

      folder = @folders.first
      expect(folder.repositories).to be_empty
      expect(folder.sub_folders).to be_empty
    end
  end
end