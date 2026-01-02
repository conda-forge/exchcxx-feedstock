#!/usr/bin/env bash

set -ex
if [[ ${cuda_compiler_version} != "None" ]]; then
  CUDA=ON
  CMAKE_ARGS="-DCMAKE_CUDA_ARCHITECTURES=70;80 ${CMAKE_ARGS}"
else
  CUDA=OFF
fi

cmake \
  -B _build \
  -G Ninja \
  -DBUILD_SHARED_LIBS=ON \
  -DEXCHCXX_ENABLE_CUDA=${CUDA} \
  -DCMAKE_REQUIRE_FIND_PACKAGE_Libxc=ON \
  ${CMAKE_ARGS}
ninja -C _build -j1
cmake --install _build
