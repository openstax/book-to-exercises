class DataStore

  def page_already_scraped?(page)
    # check to see if pages/page_id/scraped file exists
  end

  def write_source_html(page:, source_html:)

  end

  def write_exercise(page:, exercise:)
    # commit if matches committed exercise in prior page version
  end

  def approve_exercise(page:, exercise:)

  end

  def flag_exercise(page:, exercise:, note:)

  end

  def update_page_exercises_json(page:)
    # Write all committed exercises in pages/page_id/ to page_id.json in Exercises
    # search format; commit it if changed
  end

  def download
    # clone or pull, or just init if no remote
  end

  def upload

  end

end
