# CLAUDE.md

This is a Rails 8 app created by [Dispatch](https://dispatch.freeland.tools). It is deployed automatically — every push to `main` triggers a new deploy.

## Stack

- **Rails 8.1** — standard MVC, no API-only mode
- **SQLite** — four databases in production (primary, cache, queue, cable), all persisted as Docker volumes
- **Solid Queue** — background jobs, no Redis required
- **Solid Cache / Solid Cable** — cache and ActionCable backed by SQLite
- **Turbo + Stimulus** — Hotwire for frontend interactivity
- **Importmap** — JavaScript managed via import maps, no Node.js or bundler
- **Propshaft** — asset pipeline

## Local development

```bash
bin/rails db:prepare    # create and migrate all databases
bin/rails s             # start the server at localhost:3000
bin/rails test          # run the test suite
```

No Node.js, npm, or yarn. Add JavaScript packages via `bin/importmap pin <package>`.

## CI — all checks must pass before merging

| Check | Command | What fails it |
|-------|---------|---------------|
| Tests | `bin/rails test` | failing tests |
| RuboCop | `bin/rubocop` | style violations (omakase config) |
| Brakeman | `bin/brakeman --no-pager` | security warnings in Ruby code |
| bundler-audit | `bin/bundler-audit` | gems with known CVEs |
| importmap audit | `bin/importmap audit` | JS packages with known CVEs |

Run `bin/rubocop -a` to auto-fix most style issues. Add legitimate Brakeman false positives to `.brakeman.ignore`, not as inline ignores.

## Deploy model

Push to `main` → Dispatch receives the push webhook → triggers the GitHub Actions `deploy.yml` workflow → builds and pushes a Docker image to GHCR → notifies Dispatch → Dispatch runs a Kamal deploy on the server.

There is no staging environment. Changes go live on merge to main.

## Secrets — do not modify

These are injected by Dispatch at fork time. Do not create, rename, or change them:

| Name | Purpose |
|------|---------|
| `RAILS_MASTER_KEY` | Overrides `config/master.key` at build time |
| `DISPATCH_WEBHOOK_SECRET` | HMAC key for deploy webhook callbacks |
| `APP_NAME` | GitHub Actions variable — sets the GHCR image name |

The committed `config/master.key` is a template placeholder. It is overwritten by the `RAILS_MASTER_KEY` secret before every image build, so it never ships.

## Entry point

The home page is `app/controllers/home_controller.rb` → `app/views/home/index.html.erb`. The root route is `root "home#index"`. Start feature work here.

## Adding dependencies

- **Ruby gems**: `bundle add <gem>` then commit `Gemfile` and `Gemfile.lock` together
- **JavaScript**: `bin/importmap pin <package>` — no npm, no build step
- **Background jobs**: inherit from `ApplicationJob`, enqueue with `MyJob.perform_later(...)` — Solid Queue is already configured
