SHELL = /usr/bin/env bash -xeuo pipefail

ZSTD_MODULE=zstd==1.5.5.1

clean:
	rm -rf layers

build-amd64: \
	build-zstd-amd64

build-arm64: \
	build-zstd-arm64

build-zstd-amd64:
	./build.sh --name Zstd-Python3_9-Amd64  --arch amd64 --runtime-version 3.9  --module ${ZSTD_MODULE}
	./build.sh --name Zstd-Python3_10-Amd64 --arch amd64 --runtime-version 3.10 --module ${ZSTD_MODULE}
	./build.sh --name Zstd-Python3_11-Amd64 --arch amd64 --runtime-version 3.11 --module ${ZSTD_MODULE}
	./build.sh --name Zstd-Python3_12-Amd64 --arch amd64 --runtime-version 3.12 --module ${ZSTD_MODULE}

build-zstd-arm64:
	./build.sh --name Zstd-Python3_9-Arm64  --arch arm64 --runtime-version 3.9  --module ${ZSTD_MODULE}
	./build.sh --name Zstd-Python3_10-Arm64 --arch arm64 --runtime-version 3.10 --module ${ZSTD_MODULE}
	./build.sh --name Zstd-Python3_11-Arm64 --arch arm64 --runtime-version 3.11 --module ${ZSTD_MODULE}
	./build.sh --name Zstd-Python3_12-Arm64 --arch arm64 --runtime-version 3.12 --module ${ZSTD_MODULE}

format: \
	fmt-terraform-root \
	fmt-terraform-modules-layer

fmt-terraform-root:
	terraform fmt

fmt-terraform-modules-layer:
	cd modules/layer; \
	terraform fmt

.PHONY: \
	clean \
	build-amd64 \
	build-arm64 \
	build-zstd-amd64 \
	build-zstd-arm64 \
	format \
	fmt-terraform-root \
	fmt-terraform-modules-layer
