class DataStore

  def enqueue_book_version_scrape(book_version)
    abstract_method
  end

  def pending_book_version_ids
    abstract_method
  end

  def mark_book_version_scraped(book_version)
    abstract_method
  end

  def book_version_already_scraped?(book_version)
    abstract_method
  end

  def page_version_already_scraped?(page_version)
    # check to see if pages/page_id/scraped file exists
    abstract_method
  end

  def write_exercises_source_html(page_version:, source_html:)
    abstract_method
  end

  def write_exercise(page_version:, filename:, body:)
    # commit if matches committed exercise in prior page version
    abstract_method
  end

  def approve_exercise(page_version:, exercise:)
    abstract_method
  end

  def flag_exercise(page_version:, exercise:, note:)
    abstract_method
  end

  def update_page_exercises_json(page_version:)
    # Write all committed exercises in pages/page_id/ to page_id.json in Exercises
    # search format; commit it if changed
    abstract_method
  end

  def download
    # clone or pull, or just init if no remote
    abstract_method
  end

  def upload
    abstract_method
  end

  private

  def abstract_method
    raise "Abstract method called"
  end

end
