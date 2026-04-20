# E2E tests

Playwright smoke + interaction tests for the PhiaDemo app.

## Setup (once)

```sh
cd e2e
npm install
npm run install-browsers
```

## Run

```sh
# From the e2e/ directory
npm test               # headless, all specs
npm run test:headed    # visible browser
npm run test:ui        # Playwright UI mode (great for debugging)
```

Playwright auto-starts `mix phx.server` via the `webServer` config. In dev it
reuses an already-running server on :4000.

## Layout

- `tests/smoke.spec.ts` — loads each demo route and asserts zero console errors.
  This alone catches the bugs we had: `_handleEvent` crashes, unknown hooks,
  `#` invalid selectors, form-requirement errors.
- `tests/inputs.spec.ts` — focused interaction tests for the inputs page
  (slider, radio, combobox, tags, autocomplete).

Add a new file per page when you want deep interaction coverage.
