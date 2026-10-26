#!/usr/bin/env bash

set -ex
if [[ ${cuda_compiler_version} != "None" ]]; then
  CUDA=ON
  echo CUDAARCHS= $CUDAARCHS

  # c-f sets the envvar above to the values below, then cmake acts on it. but only 1/4 (linux-64 cuda13) completed in 2h.
  # Oct 2026
  # 12.9: '50-real;52-real;60-real;61-real;70-real;75-real;80-real;86-real;89-real;90a-real;100f-real;103f-real;120a-real;121f-real;121-virtual'
  # 13.4: 75-real;80-real;86-real;89-real;90a-real;100f-real;103f-real;120a-real;121f-real;121-virtual

  if [[ ${cuda_compiler_version} == 12.* ]]; then
      export CMAKE_CUDA_ARCHS="60-real;70-real;75-real;80-real;86-real;89-real;90a-real;100f-real;120a-real;121f-real;121-virtual"
  elif [[ ${cuda_compiler_version} == 13.* ]]; then
      # CUDA 13 dropped Maxwell/Pascal/Volta; minimum supported arch is Turing (75).
      export CMAKE_CUDA_ARCHS="75-real;80-real;86-real;89-real;90a-real;100f-real;120a-real;121f-real;121-virtual"
  fi
  CMAKE_ARGS="-DCMAKE_CUDA_ARCHITECTURES=${CMAKE_CUDA_ARCHS} ${CMAKE_ARGS}"
  CMAKE_BUILD_PARALLEL_LEVEL=1
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
cmake --build _build
cmake --install _build
