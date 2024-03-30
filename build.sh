#!/usr/bin/env bash

set -xeuo pipefail

usage() {
  cat <<'EOT'
build.sh --name LAYER_DIR_NAME --arch [amd64|arm64] --runtime-version RUNTIME_VERSION

  --name directory having pyproject.toml in layers (ex: layer/base)
  --arch CPU architecture
  --runtime-version use python runtime version (default: 3.12) (ex: 3.12, 3.10)
EOT
}

layer_name=""
architecture=""
runtime_version="3.12"

for args in "$@"; do
  case $args in
    '--name')
      layer_name=$2
      ;;
    '--arch')
      architecture=$2
      ;;
    '--runtime-version')
      runtime_version=$2
      ;;
    '--help')
      usage
      exit 0
      ;;
  esac
  shift
done

if [[ -z "${layer_name}" || -z "${architecture}" || -z "${runtime_version}" ]]; then
  usage
  exit 1
fi

cd "layers/$layer_name"

docker image build -f ../../Dockerfile -t $layer_name --platform linux/$architecture --build-arg="RUNTIME_VERSION=${runtime_version}" .
docker container run --name=$layer_name $layer_name
docker container cp $layer_name:/tmp/layer/python .
docker container rm $layer_name
docker image rm $layer_name
