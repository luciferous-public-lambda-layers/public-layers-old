SHELL = /usr/bin/env bash -xeuo pipefail

clean:
	find layers -type d -name python | xargs rm -rf

build:
	./build.sh --name base --arch amd64 --runtime-version 3.10

package:
	sam package \
		--s3-bucket ${SAM_ARTIFACT_BUCKET} \
		--s3-prefix layer \
		--template-file sam.yml \
		--output-template-file template.yml

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
	build \
	package \
	format \
	fmt-terraform-root \
	fmt-terraform-modules-layer

