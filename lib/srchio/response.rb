module Srchio
  class Response
    attr_accessor :success, :error, :results, :pages, :current_page, :previous_page
    
    def initialize(response)
      puts response.body
      r = response.parsed_response
      @success = r['success']
      if r['success'].nil?
        @success = false
      end
      @error = r['error']
      @pages = r['pages']
      @current_page = r['current_page']
      @next_page = r['next_page']
      @previous_page = r['previous_page']
      
      if r['results'].is_a?(Array)
        @results = []
        r['results'].each do |result|
          @results << Srchio::Result.new(result)
        end
      end
    end
  end
end