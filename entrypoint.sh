#!/bin/bash
set -ex -o pipefail

touch /tmp/build-time
cd /code
mkdir -p artifacts
if [ -n "${1}" ]; then
  RUSTFLAGS="-C link-arg=-s" cargo build --release --lib --target wasm32-unknown-unknown --package "${1}"
else
  RUSTFLAGS="-C link-arg=-s" cargo build --release --lib --target wasm32-unknown-unknown
fi
find target/wasm32-unknown-unknown/release/ -maxdepth 1 -name '*.wasm' -newer /tmp/build-time | while read -r wasm; do
    wasm-opt -Oz "${wasm}" -o "artifacts/$(basename "${wasm}" .wasm)-opt.wasm"
done
