# rails-template

A production-ready Rails 8 starting point for apps deployed via [Dispatch](https://dispatch.freeland.tools).

## How it works

This repository is a GitHub Template Repository. Dispatch forks it for each new app, injects per-app secrets and variables, and triggers the deploy workflow. The workflow builds the Docker image, pushes it to the `tierralibre-solutions` GHCR namespace, and notifies Dispatch — which performs the actual Kamal deployment.

## Required secrets and variables (injected by Dispatch at fork time)

| Name | Kind | Purpose |
|------|------|---------|
| `RAILS_MASTER_KEY` | Secret | Overwrites the committed key before every build |
| `GHCR_TOKEN` | Secret | Write-scoped PAT for `tierralibre-solutions` GHCR |
| `DISPATCH_WEBHOOK_SECRET` | Secret | HMAC key for authenticating webhook callbacks to Dispatch |
| `APP_NAME` | Variable | GHCR image name (`ghcr.io/tierralibre-solutions/{APP_NAME}`) |

## Security: shared master key

**All apps forked from this template share the same `config/master.key`.** This means anyone with access to the template repository can decrypt any forked app's `credentials.yml.enc`.

`config/master.key` is committed intentionally so the template's own CI can pass without a separately configured secret. Dispatch injects `RAILS_MASTER_KEY` at fork time; the deploy workflow overwrites the committed key before every image build, so no image ever ships the template's key.

Mitigations in v1:
- `credentials.yml.enc` in this template contains no real secrets.
- The shared key is acceptable until per-app credential rotation is implemented (v2 concern).

To rotate: run `bin/rails credentials:edit` in the forked repo with a new key, then update `RAILS_MASTER_KEY` in the repo's GitHub secrets.
