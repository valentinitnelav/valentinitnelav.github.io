#!/usr/bin/env ruby
require 'awesome_print'

# Convert html to markdown

Dir['./_posts_html/*.html'].each do |html_post|
  html_post = File.expand_path(html_post)
  md_post = html_post.gsub('_posts_html', '_posts').gsub(/.html/, '.md')

  delimiter = 0
  html = []
  frontmatter = []
  File.open(html_post, 'rb').each_line do |line|
    line = line.chomp.force_encoding('UTF-8')
    if line == '---'
      delimiter += 1
      next
    end

    # HTML
    if delimiter == 2
      html << line
    else
      frontmatter << line
    end
  end

  html = html.join("\n")
  frontmatter = frontmatter.join("\n")

  File.open('/tmp/algoliajekyll.html', 'wb') do |tmp_file|
    tmp_file.write(html)
  end
  markdown = `html2mkd /tmp/algoliajekyll.html utf-8`

  final = ['---']
  final << frontmatter
  final << '---'
  final << ''
  final << markdown

  File.open(md_post, 'w') do |file|
    file.write(final.join("\n"))
  end
end
