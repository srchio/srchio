module Srchio
  class Tag
    attr_accessor :tag, :count
    
    def initialize(result={})
      @tag = result['tag']
      @count = result['count']
    end
  end
end