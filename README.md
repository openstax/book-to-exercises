# book-to-exercises

A web tool for scraping exercise content out of raw CNX HTML and making it available as OpenStax Exercises-formatted JSON.  This tool has QA mechanisms for efficiently checking that the scraping did a good job.  The tool does not currently upload the exercise JSON to Exercises, but it will be in a good place to do so when we are ready for that.

## Development

```bash
$> ./docker/compose build
$> ./docker/compose up     # start container, run Rails server (http://0.0.0.0:3000)
$> ./docker/compose run app /bin/bash # get a bash prompt in the container
$> ./docker/compose up -d && docker attach book-to-exercises_app_1 # start rails and attach so can debug
```

## Workflow

Note: below `domain` is used as the placeholder for this site's eventual domain.

### Submitting books

This site does not (currently) watch some list of published books and scrape them all, rather it waits to be told to scrape a book.  We can revisit this approach, but it is what we have started with.

A client, e.g. a Rex build process `POST`s to `https://domain/book_versions/book_uuid@version` where `book_uuid@version` is a book UUID and version.  If the book has already been scraped, the client will get a `200` response back.  If it hasn't (and `uuid@version` exists), a `204` accepted response will be returned; this indicates that the scraping work has been queued.

There is no authentication on this `POST` call, but note that invalid book IDs will return an error.

**TODO:**
* Describe how and when queued scraping work is done, how long it normally takes

### QA'ing scraped exercises

To do QA work, you must be logged in and your user UUID must be on record.

QA work consists of approving scraped exercises or flagging scraped exercises (with a note about what is wrong).  This system does not allow the user to change the exercises.  Any changes must either be made in a new version of the source content or in the scraping code.

The home page, https://domain, shows a summary of the outstanding QA work.  From here, you can click on book titles to do QA work within that book. When QA'ing an exercise, the scraped and formatted form that works for Exercises will appear on the left of the screen; the source HTML will appear on the right of the screen.  A QA analyst can click an approve button or can fill in a text box with issues and click the flag button.  Either way, we'll set it up so that each approval or flagging takes the user to the next exercise to review.

When an exercise is approved, any exercises with the same source content in older or newer versions of that page will also be approved.  When a new book is scraped, any of its exercises that are approved in older versions of the book pages will be automatically approved.  This should lead to us only ever QA'ing one exercise once.

### Getting Exercises JSON

This site returns JSON in the Exercises search results format.  It is expected that clients will want this data on a page-by-page basis, e.g. during a Rex build of the page identified by page_uuid@version, the build client will want to pull the JSON for that page.

The client will `GET` `https://domain/page_versions/page_uuid@version.json`.  This will return a 200 with content if it is available, or a 404 if not available. Note that the result will only contain the exercises from the page that have been approved through the QA process, meaning that as QA continues this result will change until all exercises have been approved.

Because the content served here is openly-available, there is no authentication on these `GET`s.  The `GET`s are served through CloudFront so are scalable, but the clients may want to make their own copy to reduce SSL handshake time.

## TODO

* When page exercises JSON files are updated, touch something to trigger an s3 sync on next cron run (or manual call can check this)
* Have a list of gsubs, e.g. "For the following exercises, simplify the expression." --> "Simplify the expression"
* Keep cached counts of unprocessed exercises by book so we can show that
* When show QA view of problem vs source, dynamically remove all other exercises ("...") except for the exercise in question (so can still see prompts, etc)
* TODO cron job that periodically scrapes previously-scraped flagged content in case the scraping code has changed and the scraping is fixed.  Should never rescrape approved content.
* Basic Bootstrap layout
