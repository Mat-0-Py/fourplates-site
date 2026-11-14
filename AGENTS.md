# Four Plates website — agent instructions

Binding rules for any coding agent working in this repository.

This is the website for **Four Plates**, Mat Leach's lifting log for iPhone, at
<https://fourplates.app>. It holds the product page, How it works, the privacy policy, the terms
and support, hosted on GitHub Pages. fourplates.co.uk forwards here.

The app's repository (`FitnessApp`) is the source of truth for everything the app says. This site
repeats it; it never leads.

## Hard rules

- **Static and plain.** HTML and CSS. No build step, framework, package manager or generator.
- **No tracking, nothing loaded from elsewhere.** No analytics, cookies, trackers or third-party
  scripts, and no page loads anything from another host (`src`, CSS `url()`, `@import`, `fetch`).
  Fonts are the system's own. Ordinary links (`href`) to other sites are fine where a page needs
  them, such as the terms pointing to Apple's standard licence.
- **Legal pages are word for word.** The privacy policy, terms and the "Before you start" notice
  match the app (`PrivacyView`, `docs/legal.md` in FitnessApp) exactly. Never reword them here;
  change the app's copy first, with Mat's say-so, then copy it across.
- **How it works is word for word** with `HowChalkWorksView.swift` in FitnessApp. When a topic
  changes there, copy the changed topic here.
- **`routine-template.csv` stays identical** to `Website/routine-template.csv` in FitnessApp, which a
  test keeps equal to the app's template.
- **Facts only.** Describe what the app does. No health or performance claims ("build muscle",
  "prevent injury"), no invented ratings, download counts or dates. Prices match
  `docs/product.md`: never a struck-through "was" price or invented urgency.
- **No other brand names.** Never name or compare with other apps or companies. Apple's platform
  names (iPhone, Apple Watch, iCloud, App Store, Siri) are the only exception. No Apple artwork or
  SF Symbols, except Apple's official App Store badge, unmodified, once the app is live, and
  screenshots of Four Plates itself in `screens/`, which show the app's own controls and the
  iPhone's status bar as the app does (Mat, 14 Nov 2026). Refresh them with
  `tools/update-screens.sh`; never draw over them or add other apps' screens.
- **Colour is data, chrome is ink.** Muscle-group colours only ever mean a muscle group; links,
  buttons and text are ink. Yellow is never text.
- **UK English**, plain and warm, no hype.
- **Paths:** pages link to each other relatively; `404.html` uses root paths (`/style.css`) so it
  works at any missing address.
- Commit on a branch; don't push. Mat publishes.
