#!/usr/bin/env bash
set -e

echo "==> Installing dependencies..."
mix deps.get --only prod

echo "==> Compiling (prod)..."
MIX_ENV=prod mix compile

echo "==> Building assets (installs binaries if missing)..."
MIX_ENV=prod mix assets.build

echo "==> Deploying assets (minify + digest)..."
MIX_ENV=prod mix assets.deploy

echo "==> Generating release..."
MIX_ENV=prod mix phx.gen.release
MIX_ENV=prod mix release --overwrite

echo "==> Build complete."
