# ECHO Locale

**Locale/language customizations for the ECHOcommunity Discourse forum** — keeps the forum's
language in step with the main site and trims UI that doesn't fit the ECHOcommunity layout.

> **Part of the [ECHOcommunity Discourse setup](https://github.com/ECHOInternational/discourse-infrastructure)** — the self-hosted Discourse at `conversations.echocommunity.org`.
> Family: [infrastructure](https://github.com/ECHOInternational/discourse-infrastructure) · [echo-login](https://github.com/ECHOInternational/discourse-echo-login) · **echo-locale** · [echo-nav](https://github.com/ECHOInternational/discourse-echo-nav) · [ECHOcommunity (main site)](https://github.com/ECHOInternational/ECHOcommunity)

## Overview
The ECHOcommunity site drives language with a `?locale=` parameter (the language switcher in the
shared header — see [echo-nav](https://github.com/ECHOInternational/discourse-echo-nav)). This
plugin makes the forum honor that param and maps the main site's locale codes onto the locales
Discourse actually ships. It also hides Discourse's search button (the shared header provides its
own search).

## How it works
- **Locale resolution:** prepends a module to `ApplicationController` that overrides the
  `with_resolved_locale` around-action. When a `?locale=` param is present it is run through
  `map_locale` and applied; otherwise it defers to Discourse's native resolution.
- **`map_locale`:** `zh → zh_CN`; `my, th, sw, km → en` (no Discourse translation); everything else
  passes through unchanged (so `zh_CN`, `es`, `fr`, `pt`, … are preserved).
- **`default_url_options`:** appends the current `locale` to generated URLs.
- **`stylesheets/hacks.css`:** hides the forum's search button.

## Compatibility & branches
- **Discourse v2026.1 (ESR)** — Rails 8 / Ruby 3.4.
- **Production branch: `v2026.1-compat`** (currently v3.0.1) — what the deploy clones.
- Note: older versions overrode a `set_locale` method that no longer exists in Discourse
  (locale is resolved via `with_resolved_locale`); the current version uses a prepended module so
  `super` reaches the real implementation.
- ⚠️ `master` is legacy. The live code is on **`v2026.1-compat`**.

## Installation
In the Discourse container config / CloudFormation `after_code` hook:
```yaml
- git clone --branch v2026.1-compat https://github.com/ECHOInternational/discourse-echo-locale.git
```
