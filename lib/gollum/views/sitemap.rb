require 'xml-sitemap'

class SitemapView
  
  include Precious::Views::AppHelpers
  include Precious::Views::RouteHelpers
  
  attr_reader :base_url
  
  def initialize(wiki_title, domain, pages, opts)
    @wiki_title = wiki_title
    @domain = domain
    @pages = pages
    @secure = opts[:secure] || false
    @gzip = opts[:gzip] || false
    @add_ext  = opts[:add_ext] || false
  end
  
  def render
    puts @url
    map = XmlSitemap::Map.new(@domain, {secure: @secure}) do |m|
      @pages.each do |page|
        version = page.last_version
        path = page.path
        m.add path, :updated => version.authored_date
        if File.extname(path) == '.md'
          path = File.basename(path, File.extname(path))
          m.add path, :updated => version.authored_date
        end
      end
    end.render

    @gzip ? Zlib::gzip(map) : map
  end
end
