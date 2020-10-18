class Scraper1
  include DataStorable

  def scrape(page_version)
    if !data_store.page_version_already_scraped?(page_version)
      exercises_sections = page_version.search('.exercises, .section-exercises')

      if !exercises_sections.empty?
        data_store.write_exercises_source_html(page_version: page_version,
                                               source_html: exercises_sections.to_xhtml)

        exercises_sections.search('[data-type="exercise"]').each do |exercise|
          data_store.write_exercise(page_version: page_version,
                                    filename: "#{exercise['id']}.json",
                                    body: {stuff: exercise.children.to_s})
        end
      end
    end

    # TODO also do this on cron to get QA'd items
    data_store.update_page_exercises_json(page_version: page_version)
  end

end
