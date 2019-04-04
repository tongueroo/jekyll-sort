require "net/http"
require "nokogiri"

module JekyllSort
  class Reorder
    def initialize(options)
      @options = options
    end

    def run
      check_in_docs_folder!

      uri = URI('http://localhost:4000/docs/')
      begin
        body = Net::HTTP.get(uri) # => String
      rescue Errno::ECONNREFUSED => e
        puts e
        puts "ERROR: Please make sure the jekyll server is running and server docs.  You can use:"
        puts "  bin/web"
      end

      PrevNext.new.create
      Page.reset_all

      doc = Nokogiri::HTML(body)
      links = doc.search('.content-nav a')
      links.each_with_index do |link, i|
        page = Page.new(link[:href], i+1)
        page.update
      end
    end

    def check_in_docs_folder!
      parent_folder = File.basename(Dir.pwd)
      if parent_folder != "docs"
        puts "Please run this command within the docs folder"
        exit 1
      end
    end
  end
end
