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

## Git hook (pre-merge-commit)

The repo ships a `.githooks/pre-merge-commit` that runs the smoke suite
before a merge commit is finalised. Enable it once per clone with:

```sh
git config core.hooksPath .githooks
```

It only fires on non-fast-forward merges; a plain `git pull` that
fast-forwards will not trigger it. Bypass with `git merge --no-verify`.
