require 'fileutils'

module JekyllSort
  class PrevNext
    def create
      src = File.expand_path("../template/_includes/prev_next.md", File.dirname(__FILE__))
      dest = "_includes/prev_next.md"
      FileUtils.mkdir_p(File.dirname(dest))
      FileUtils.cp(src, dest)
    end
  end
end
