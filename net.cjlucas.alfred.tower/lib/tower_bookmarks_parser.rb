require 'rexml/document'
require 'uri'

module TowerWorkflow
  class Folder
    attr_reader :name, :sub_folders, :repositories

    def initialize(name = nil)
      @name = name
      @sub_folders = []
      @repositories = []
    end

    def <<(object)
      if object.is_a?(Folder)
        sub_folders << object
      elsif object.is_a?(Repository)
        repositories << object
      end
    end

    def all_repositories
      repos = repositories.dup
      sub_folders.each { |folder| repos += folder.all_repositories }
      repos
    end

    def has_folder?(folder_name)
      !sub_folders.select { |folder| folder.name.eql?(folder_name) }.empty?
    end

    def has_repository?(repository_name)
      !repositories.select { |repo| repo.name.eql?(repository_name)}.empty?
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
    def self.get_bookmarks(bookmarks_path)
      new(bookmarks_path).get_bookmarks
    end

    def initialize(bookmarks_path)
      path = File.new(File.expand_path(bookmarks_path))
      raise unless File.exists?(path)

      @xml = REXML::Document.new(path)
    end

    def get_bookmarks
      @parsed ||= parse

      process_parsed_data(@parsed)
    end

    private

    def process_parsed_data(data)
      Folder.new.tap do |top_level_folder|
        data.each { |hash| process_parsed_hash(hash, top_level_folder) }
      end
    end

    def process_parsed_hash(hash, current_folder)
      if valid_repository?(hash)
        file_uri = URI.parse(hash['fileurl'])
        hash['fileurl'] = URI.unescape(file_uri.path)
        current_folder << repository_from_hash(hash)
      elsif folder?(hash)
        folder = folder_from_hash(hash)
        current_folder << folder
        hash['children'].each { |child| process_parsed_hash(child, folder) }
      end
    end

    def valid_repository?(hash)
      hash.has_key?('fileurl')
    end

    def folder?(hash)
      hash.has_key?('children') && hash.has_key?('name')
    end

    def repository_from_hash(hash)
      Repository.new(hash['name'], hash['fileurl'])
    end

    def folder_from_hash(hash)
      Folder.new(hash['name'])
    end

    ## XML Parsing

    def process_dict_element(dict_elem)
      dict = {}
      current_key = nil

      dict_elem.each_element do |elem|
        if elem.name.eql?('key')
          current_key = elem.text.downcase
          next
        end

        dict[current_key] = case elem.name
                            when 'string'
                              elem.text
                            when 'dict'
                              parse_dict_element(elem)
                            when 'array'
                              process_array_element(elem)
                            end
      end

      dict
    end

    def process_array_element(array_elem)
      array = []
      array_elem.get_elements('dict').each do |elem|
        array << process_dict_element(elem)
      end

      array
    end

    def parse
      root_dict = @xml.elements.to_a.first.get_elements('dict').first

      bookmarks = []
      root_dict.get_elements('array').each do |array_elem|
        bookmarks += process_array_element(array_elem)
      end

      bookmarks
    end
  end
end

