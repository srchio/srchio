module Srchio
  class Result
    attr_accessor :title, :highlight, :url, :tags, :remote_id, :index_id
    
    def initialize(result={})
      @title = result['title']
      @highlight = result['highlight']
      @url = result['url']
      @tags = result['tags']
      @remote_id = result['remote_id']
      @index_id = result['index_id']
    end
  end
end