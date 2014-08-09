require 'rexml/document'

module TowerWorkflow
  class Folder
    attr_reader :sub_folders, :repositories

    def initialize
      @sub_folders = []
      @repositories = []
    end
  end

  class Repository
    attr_reader :name, :location

    def initialize(name, location)
      @name = name
      @location = location
    end
  end

  class BookmarksParser
    def self.get_folders(bookmarks_path)
      new(bookmarks_path).get_folders
    end

    def initialize(bookmarks_path)
      path = File.new(File.expand_path(bookmarks_path))
      raise unless File.exists?(path)

      @xml = REXML::Document.new(path)
    end

    def get_folders
      []
    end

    private
    #
    # def process_dict_element(dict_elem)
    #   dict = {}
    #   current_key = nil
    #
    #   dict_elem.each_element do |elem|
    #     if elem.name.eql?('key')
    #       current_key = elem.text
    #       next
    #     end
    #
    #     dict[current_key] = case elem.name
    #                         when 'string'
    #                           elem.text
    #                         when 'dict'
    #                           parse_dict_element(elem)
    #                         when 'array'
    #                           []
    #                         end
    #   end
    #
    #   dict
    # end
    #
    # def process_array_element(array_elem)
    #   array = []
    #   array_elem.get_elements('dict').each { |elem| process_dict_element(elem) }
    # end
    #
    # def parse
    #   root_dict = @xml.elements.to_a.first.elements('dict').first
    #
    #   root_dict.get_elements('array').each do |array_elem|
    #   end
    # end
  end
end

