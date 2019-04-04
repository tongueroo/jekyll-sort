require "front_matter_parser"
require "yaml"

module JekyllSort
  class Page
    def self.reset_all
      paths = Dir.glob("**/**.md")
      paths.each do |path|
        link = path.sub('_','/').sub(/\.md$/,'/') # _docs/dsl.md => /docs/dsl/
        link = "/#{link}" unless link =~ /^\//    # quick-start  => /quick-start
        Page.new(link, :delete).update
      end
    end

    def initialize(link, nav_order)
      @link, @nav_order = link, nav_order
    end

    def update
      return if @link =~ /reference/ || @link =~ /includes/ || @link =~ /site/

      page_path = @link.sub('/','').sub(/\/$/,'') + ".md" # remove leading /
      page_path = "_#{page_path}" if page_path =~ /^docs\//

      # puts "@link #{@link}"
      # puts "page_path #{page_path}"

      unless File.exist?(page_path)
        puts "WARN: path #{page_path} not found"
        return
      end


      if @nav_order == :delete
        puts "Deleting prev next info: #{page_path}"
        content = delete_prev_next_info(page_path)
      else
        puts "Updating #{page_path} with nav_order #@nav_order"
        content = update_prev_next_info(page_path)
      end

      return unless content

      IO.write(page_path, content)
    end

    def update_prev_next_info(page_path)
      front_matter, parsed = parse(page_path)
      return if front_matter.empty? # only add to front matter if there already a front matter

      front_matter["nav_order"] = @nav_order
      content = new_content(front_matter, parsed.content)
      content = remove_old_prev_next_links(content)
      content = ensure_new_prev_next_links(content)
    end

    def delete_prev_next_info(page_path)
      front_matter, parsed = parse(page_path)
      return if front_matter.empty? # only add to front matter if there already a front matter

      front_matter.delete("nav_order")
      content = new_content(front_matter, parsed.content)
      content = remove_prev_next_link(content)
    end

    def new_content(front_matter, content)
      new_front_matter = YAML.dump(front_matter)
      "#{new_front_matter}---\n\n#{content}"
    end

    def parse(page_path)
      parsed = FrontMatterParser::Parser.parse_file(page_path)
      front_matter = parsed.front_matter
      [front_matter, parsed]
    end

    PREV_NEXT_MARKDOWN = "\n{% include prev_next.md %}"

    def remove_prev_next_link(content)
      content.sub(PREV_NEXT_MARKDOWN, '')
    end

    def ensure_new_prev_next_links(content)
      if content.include?(PREV_NEXT_MARKDOWN)
        content
      else
        content + "\n" + PREV_NEXT_MARKDOWN
      end
    end

    # Hack to remove old next prev links. Just always call it for old sites.
    def remove_old_prev_next_links(content)
      result = []
      lines = content.split("\n")
      lines.each do |l|
        unless l.include?('<a id="prev" ') ||
              l.include?('<a id="next" ') ||
              l.include?('<p class="keyboard-tip')
          result << l
        end
      end
      result.join("\n")
    end
  end
end
