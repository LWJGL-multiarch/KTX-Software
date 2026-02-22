#!/usr/bin/env bash

cd "$(dirname "${BASH_SOURCE[0]}")"

# sudo apt install cmake ninja-build

git config --global --add safe.directory $(pwd)
git remote add upstream https://github.com/KhronosGroup/KTX-Software.git
git fetch --all --tags

cmake -B build \
    -G Ninja \
    -DCMAKE_C_FLAGS:STRING="-U_FORTIFY_SOURCE -D_FORTIFY_SOURCE=0" \
    -DBASISU_SUPPORT_OPENCL=OFF -DKTX_FEATURE_TESTS=OFF -DKTX_FEATURE_TOOLS=OFF
cmake --build build --parallel --target ktx
strip ./build/libktx.so

# Copy result to output directory
LWJGL_OUTPUT_DIR="${LWJGL_OUTPUT_DIR:-/tmp/lwjgl3-build/output}"

mkdir -p "$LWJGL_OUTPUT_DIR"
cp ./build/libktx.so "$LWJGL_OUTPUT_DIR/libktx.so"
