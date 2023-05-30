#!/bin/sh

cargo build --lib --release --target wasm32-unknown-unknown
wasm-bindgen --target web --no-typescript --out-dir docs/assets target/wasm32-unknown-unknown/release/rainbow_filter.wasm
wasm-strip docs/assets/rainbow_filter_bg.wasm