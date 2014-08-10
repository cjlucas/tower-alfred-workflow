require_relative '../bundle/bundler/setup'

require 'alfredlite'
require 'alfredlite/feedback'
require 'fuzzy_match'

require_relative 'tower_bookmarks_parser'

module TowerWorkflow
  class Workflow < Alfred::Workflow
    REPO_ICON = 'CloneRepoIcon.png'

    def initialize(bookmarks_path)
      super('net.cjlucas.alfred.tower')
      @bookmarks_path = File.expand_path(bookmarks_path)
    end

    def find_repos(query)
      @repositories ||= BookmarksParser.get_bookmarks(@bookmarks_path) \
                        .all_repositories

      query.nil? || query.empty? \
      ? @repositories \
        : FuzzyMatch.new(@repositories, read: :name).find_all(query)
    end

    def query(query = nil)
      find_repos(query).each do |repo|
        feedback_items << Alfred::Feedback::Item.new.tap do |item|
          item.title = repo.name
          item.subtitle = repo.location
          item.arg = repo.location
          item.icon = REPO_ICON
        end
      end

      feedback_xml.write
    end
  end
end
