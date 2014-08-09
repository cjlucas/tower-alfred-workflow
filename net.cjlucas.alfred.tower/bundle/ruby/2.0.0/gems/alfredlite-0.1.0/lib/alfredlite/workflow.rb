require 'fileutils'

module Alfred
  class Workflow
    CACHE_DIR = '/Library/Caches/com.runningwithcrayons.Alfred-2/Workflow Data'
    DATA_DIR = '/Library/Application Support/Alfred 2/Workflow Data' 
    attr_reader :bundle_id
    
    def initialize(bundle_id)
      @bundle_id = bundle_id
    end

    def storage_path
      @storage_path ||= File.join(ENV['HOME'], DATA_DIR, bundle_id)
      self.class.mkdir(@storage_path)
      @storage_path
    end

    def volatile_storage_path
      @volatile_storage_path ||= File.join(ENV['HOME'], CACHE_DIR, bundle_id)
      self.class.mkdir(@volatile_storage_path)
      @volatile_storage_path
    end

    def query(input)
    end

    private
    
    def self.mkdir(path)
      FileUtils.mkdir_p(path) unless File.exists?(path)
    end
  end
end
