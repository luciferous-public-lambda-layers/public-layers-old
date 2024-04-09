SHELL = /usr/bin/env bash -xeuo pipefail

ZSTD_VERSION=1.5.5.1

clean:
	rm -rf layers

build-amd64: \
	build-zstd-amd64

build-arm64: \
	build-zstd-arm64

build-zstd-amd64:
	./build.sh --name zstd-python39-amd64  --arch amd64 --runtime-version 3.9  --module zstd==${ZSTD_VERSION}
	./build.sh --name zstd-python310-amd64 --arch amd64 --runtime-version 3.10 --module zstd==${ZSTD_VERSION}
	./build.sh --name zstd-python311-amd64 --arch amd64 --runtime-version 3.11 --module zstd==${ZSTD_VERSION}
	./build.sh --name zstd-python312-amd64 --arch amd64 --runtime-version 3.12 --module zstd==${ZSTD_VERSION}

build-zstd-arm64:
	./build.sh --name zstd-python39-arm64  --arch arm64 --runtime-version 3.9  --module zstd==${ZSTD_VERSION}
	./build.sh --name zstd-python310-arm64 --arch arm64 --runtime-version 3.10 --module zstd==${ZSTD_VERSION}
	./build.sh --name zstd-python311-arm64 --arch arm64 --runtime-version 3.11 --module zstd==${ZSTD_VERSION}
	./build.sh --name zstd-python312-arm64 --arch arm64 --runtime-version 3.12 --module zstd==${ZSTD_VERSION}

lint: \
	lint-python \
	lint-templates

lint-python: \
	lint-python-isort \
	lint-python-black

lint-python-isort:
	poetry run isort --profile=black --check generate_bucket_name.py

lint-python-black:
	poetry run black --check generate_bucket_name.py

lint-templates:
	poetry run cfn-lint templates/*.yml

deploy-artifacts-bucket:
	sam deploy \
		--stack-name artifacts-bucket \
		--template-file templates/artifacts_bucket.yml \
		--parameter-overrides ArtifactsBucketName=$$(./generate_bucket_name.py) \
		--no-fail-on-empty-changeset

delete-artifacts-bucket:
	sam delete \
		--stack-name artifacts-bucket

create-change-set-artifacts-bucket:
	sam deploy \
		--stack-name artifacts-bucket \
		--template-file templates/artifacts_bucket.yml \
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
	lint-templates \
	deploy-artifacts-bucket \
	create-change-set-artifacts-bucket
