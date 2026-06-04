# rails-template

A production-ready Rails 8 starting point for apps deployed via [Dispatch](https://dispatch.freeland.tools). Every push to `main` triggers an automatic deploy — there is no manual deploy step.

## What's included

- **Rails 8.1** with SQLite (via Solid Queue, Solid Cache, Solid Cable — no Redis)
- **Turbo + Stimulus** for frontend interactivity
- **Importmap** for JavaScript — no Node.js or build step required
- **Propshaft** asset pipeline
- CI via GitHub Actions: tests, RuboCop, Brakeman, bundler-audit, importmap audit

## Getting started locally

```bash
bin/rails db:prepare   # create and migrate all databases
bin/rails s            # http://localhost:3000
bin/rails test         # run the test suite
```

## Deploy

Push to `main`. Dispatch handles the rest — it triggers a GitHub Actions build, pushes the Docker image to GHCR, and runs a Kamal deploy on the server. Deploys typically complete within a few minutes.

## Adding dependencies

- **Ruby gems**: `bundle add <gem>` — commit `Gemfile` and `Gemfile.lock` together
- **JavaScript**: `bin/importmap pin <package>` — no npm, no build step

## CI checks

All of these run on every pull request and push to `main`:

| Check | What it catches |
|-------|----------------|
| `bin/rails test` | failing tests |
| `bin/rubocop` | style violations |
| `bin/brakeman` | Ruby security issues |
| `bin/bundler-audit` | gems with known CVEs |
| `bin/importmap audit` | JS packages with known CVEs |

## Secrets

Secrets are injected by Dispatch at fork time. `RAILS_MASTER_KEY`, `DISPATCH_WEBHOOK_SECRET`, and the `APP_NAME` variable are already configured — do not modify them.

The committed `config/master.key` is a placeholder overwritten by `RAILS_MASTER_KEY` before every image build, so it never ships in production.
