#!/bin/bash 
bin/macosx/tundra/tundra2 -v macosx-clang-debug
cargo build
cargo build --manifest-path=src/plugins/bitmap_memory/Cargo.toml
cargo build --manifest-path=src/prodbg/tests/rust_api_test/Cargo.toml

