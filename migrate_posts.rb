#!/usr/bin/env ruby

require 'date'

origin_path = 'posts'
destination_path = 'content/blog'

Post = Struct.new(:title, :slug, :date, :draft, :tags, :categories, :body)

posts = []

Dir.chdir(origin_path) do
  files = Dir.glob('*.md')

  files.each do |file|
    post = Post.new

    parts = File.read(file).split("-->\n")

    raise if parts.length > 2

    post.body = parts.slice(1..).join("\n")

    File.foreach(file) do |line|
      if line =~ /\.\. title/
        title = line.match(/title:\ (.*)/).captures.first
        post.title = title
      elsif line =~ /\.\. slug/
        slug = line.match(/slug:\ (.*)/).captures.first
        post.slug = slug
      elsif line =~ /\.\. date/
        date = line.match(/date:\ (.*)/).captures.first
        post.date = Date.parse(date).strftime('%Y-%m-%d')
      elsif line =~ /\.\. status/
        if line.match?(/draft/) || line.match?(/private/)
          post.draft = true
        end
      elsif line =~ /\.\. tags/
        tags = line.match(/tags:\ (.*)/)&.captures&.first&.split(',')
        
        if tags && tags.any?
          tags = tags.join('", "')
          post.tags = "\[\"#{tags}\"\]" if !tags.nil?
        end
      elsif line =~ /\.\. category/
        categories = line.match(/category:\ (.*)/)&.captures&.first&.split(',')

        if categories && categories.any?
          categories = categories.join('", "')
          post.categories = "\[\"#{categories}\"\]" if !categories.nil?
        end
      end
    end

    posts << post

    File.delete(file)
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
