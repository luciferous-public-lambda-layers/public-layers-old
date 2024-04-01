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

lint: \
	lint-python \
	lint-template

lint-python: \
	lint-python-isort \
	lint-python-black

lint-python-isort:
	poetry run isort --profile=black --check generate_bucket_name.py

lint-python-black:
	poetry run black --check generate_bucket_name.py

lint-template: \
	lint-template-artifacts-bucket

lint-template-artifacts-bucket:
	poetry run cfn-lint template_artifacts_bucket.yml

deploy-artifacts-bucket:
	sam deploy \
		--stack-name artifacts-bucket \
		--template-file template_artifacts_bucket.yml \
		--parameter-overrides ArtifactsBucketName=$$(./generate_bucket_name.py) \
		--no-fail-on-empty-changeset

create-change-set-artifacts-bucket:
	sam deploy \
		--stack-name artifacts-bucket \
		--template-file template_artifacts_bucket.yml \
		--parameter-overrides ArtifactsBucketName=$$(./generate_bucket_name.py) \
		--no-fail-on-empty-changeset \
		--no-execute-changeset

.PHONY: \
	clean \
	build-amd64 \
	build-arm64 \
	build-zstd-amd64 \
	build-zstd-arm64 \
	lint \
	lint-template-bucket \
	deploy-artifacts-bucket \
	create-change-set-artifacts-bucket
