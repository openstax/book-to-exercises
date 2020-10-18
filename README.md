# book-to-exercises

```bash
$> ./docker/build
$> ./docker/bash
% /code> cd src
% /code/src> bundle install
```

## TODO

* When page exercises JSON files are updated, touch something to trigger an s3 sync on next cron run (or manual call can check this)
* Have a list of gsubs, e.g. "For the following exercises, simplify the expression." --> "Simplify the expression"
* Keep cached counts of unprocessed exercises by book so we can show that
* POST book UUID @ version writes books/UUID@version/.gitkeep and pushes it.  Single daemon watches this folder, when sees new folder, scrapes it, then writes books/UUID@version/scraped; if POST comes in and `scraped` file exists, returns 200s
* When show QA view of problem vs source, dynamically remove all other exercises ("...") except for the exercise in question (so can still see prompts, etc)
