$:.unshift(File.expand_path("../", __FILE__))
require "jekyll_sort/version"
require "rainbow/ext/string"

module JekyllSort
  class Error < StandardError; end

  autoload :CLI, "jekyll_sort/cli"
  autoload :Command, "jekyll_sort/command"
  autoload :Completer, "jekyll_sort/completer"
  autoload :Completion, "jekyll_sort/completion"
  autoload :Help, "jekyll_sort/help"
  autoload :Sub, "jekyll_sort/sub"
end
