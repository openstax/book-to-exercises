class BookVersionsController < ApplicationController

  def create
    book_version = BookVersion.new(params[:id])

    if book_version.scraped?
      head :success
    else
      if book_version.exists?
        book_version.enqueue_scrape
        head :accepted
      else
        head :unprocessable_entity
      end
    end
  end

end
