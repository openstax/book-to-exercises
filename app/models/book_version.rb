require_relative 'content'
require_relative 'page_version'

class BookVersion < Content
  def pages
    return @pages if !@pages.nil?

    @pages = []
    add_pages_from_contents(json['tree']['contents'], @pages)
    @pages
  end

  def enqueue_scrape
    data_store.enqueue_book_version_scrape(self)
  end

  def self.scrape_all_pending
    data_store!.pending_book_version_ids.each do |book_version_id|
      book_version = new(book_version_id)
      book_version.scrape
      data_store.mark_book_version_scraped(book_version)
    end
  end

  def scrape
    # TODO write some book metadata to /books/UUID@version so we can show real titles
    # etc in views
    pages.each do |page|
      scraper.scrape(page)
    end

    # TODO do one commit here for the whole scrape

    data_store.mark_book_version_scraped(self)
  end

  def scraped?
    data_store.book_version_already_scraped?(self)
  end

  protected

  def add_pages_from_contents(contents, pages)
    contents.each do |contents_entry|
      if contents_entry.has_key?('contents')
        add_pages_from_contents(contents_entry['contents'], pages)
      else
        pages.push(PageVersion.new(contents_entry['id']))
      end
    end
  end

  def scraper
    # Could give different scrapers by book
    @scraper ||= Scraper1.new
  end
end
