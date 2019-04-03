require "bundler/gem_tasks"
require "rspec/core/rake_task"

task default: :spec

RSpec::Core::RakeTask.new

require_relative "lib/jekyll-sort"
require "cli_markdown"
desc "Generates cli reference docs as markdown"
task :docs do
  CliMarkdown::Creator.create_all(cli_class: JekyllSort::CLI, cli_name: "jekyll-sort")
end
