#!/usr/bin/env ruby

require 'date'

origin_path = 'posts'
destination_path = 'content/blog'

Post = Struct.new(:title, :slug, :date, :draft, :tags, :categories, :body)

posts = []

Dir.chdir(origin_path) do
  files = Dir.glob('*.meta')

  files.each do |file|
    filename_parts = file.split('.').slice(0...-1)

    metadata_filename = (filename_parts + ['meta']).join('.')
    content_filename= (filename_parts + ['md']).join('.')

    post = Post.new

    if File.exist?(content_filename)
      post.body = File.read(content_filename).delete_prefix('<html><body>').delete_suffix('</body></html>')
    else
      next
    end

    File.foreach(metadata_filename) do |line|
      if line =~ /title/
        title = line.match(/title:\ (.*)/).captures.first
        post.title = title
      elsif line =~ /slug/
        slug = line.match(/slug:\ (.*)/).captures.first
        post.slug = slug
      elsif line =~ /date/
        date = line.match(/date:\ (.*)/).captures.first
        post.date = Date.parse(date).strftime('%Y-%m-%d')
      elsif line =~ /status/
        post.draft = true if line.match?(/draft/)
      elsif line =~ /tags/
        tags = line.match(/tags:\ (.*)/).captures.first.split(',').join('", "')
        post.tags = "\[\"#{tags}\"\]"
      elsif line =~ /category/
        categories = line.match(/category:\ (.*)/).captures.first.split(',').join('", "')
        post.categories = "\[\"#{categories}\"\]"
      end
    end

    posts << post

    # File.delete(metadata_filename)
    # File.delete(content_filename)
  end
end

Dir.chdir(destination_path) do
  posts.each do |post|
    filename = "#{post.date}_#{post.slug}.md"

    qmark = if post.title.match?(/"/)
              "'"
            else
              '"'
            end

    File.open(filename, "w") do |f| 
      f.write "---\n"
      f.write "title: #{qmark}#{post.title}#{qmark}\n"
      f.write "slug: #{post.slug}\n"
      f.write "date: #{post.date}\n"
      if post.tags || post.categories
        f.write "taxonomies:\n"
        f.write "  tags: #{post.tags}\n"
        f.write "  categories: #{post.categories}\n"
      end
      f.write "draft: true\n" if post.draft == true
      f.write "---\n\n"

      f.write post.body
    end
  end
end
