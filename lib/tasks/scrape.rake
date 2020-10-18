desc <<-DESC.strip_heredoc
  Scrapes pending book versions.
DESC
task scrape_pending_book_versions: :environment do
  Rails.logger.info { "Starting scrape_pending_book_versions..." }

  BookVersion.scrape_all_pending

  # TODO do this in a loop with a sleep(60) at end, maybe based on a continuous arg

  Rails.logger.info { "Ending scrape_pending_book_versions" }
end
