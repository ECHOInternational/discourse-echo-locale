# Discourse modifications for Locale compatability with ECHOcommunity

## What it does:
  - Sets the locale based on the accepts-language header
  - Accepts-Languge overridden by a `locale` parameter
  - Sets the Site title to a translated string (when no logo used)
  - Hides the search button
  - Adds the locale to all ajax calls

## Todo:
  - Match available translations to ECHOcommunity