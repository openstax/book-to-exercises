require_relative 'content'
require_relative 'page'

class Book < Content
  def pages
    return @pages if !@pages.nil?

    @pages = []
    add_pages_from_contents(json['tree']['contents'], @pages)
    @pages
  end

  def scrape(data_store:)
    # TODO write some book metadata to /books/UUID@version so we can show real titles
    # etc in views
    pages.each do |page|
      if !data_store.page_already_scraped?(page)
        exercises = page.exercises
        next if exercises.empty?

        data_store.write_source_html(page: page, source_html: exercises.source_html)

        exercises.each do |exercise|
          data_store.write_exercise(page: page, exercise: exercise)
        end
      end

      # TODO also do this on cron to get QA'd items
      data_store.update_page_exercises_json(page: page)
    end
  end

  private

  def add_pages_from_contents(contents, pages)
    contents.each do |contents_entry|
      if contents_entry.has_key?('contents')
        add_pages_from_contents(contents_entry['contents'], pages)
      else
        pages.push(Page.new(contents_entry['id']))
      end
    end
  end
end
