require_relative '../vendor/setup'

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

      $stderr.puts("All repositories: #{@repositories}")

      query.nil? || query.empty? \
      ? @repositories \
        : FuzzyMatch.new(@repositories, read: :name).find_all(query)
    end

    def query(query = nil)
      $stderr.puts %Q{Received query: "#{query}"}

      find_repos(query).each do |repo|
        feedback_items << Alfred::Feedback::Item.new.tap do |item|
          item.add_title(repo.name)
          item.add_subtitle(repo.location)
          item.arg = repo.location
          item.add_icon(REPO_ICON)
        end
      end

      send_feedback!
    end
  end
end
