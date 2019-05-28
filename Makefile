MAKEFLAGS=--warn-undefined-variables

# Parameters
-include credentials.mk
DOC_PORT ?= 8000

# Internal Variables
docker_image = imsardine/mkdocs
docker_opts =
uid = $(shell id -u)

define docker_run
	docker run --rm -it \
	  --user $(uid) \
	  --volume $(PWD):/workspace \
	  $(docker_opts) \
	  $(docker_image) $(1)
endef

build:
	docker build -t $(docker_image) .

shell: docker_opts += --entrypoint= --publish $(DOC_PORT):8000
shell:
	$(call docker_run,bash)

preview: docker_opts += --publish $(DOC_PORT):8000
preview:
	$(call docker_run,serve --dev-addr 0.0.0.0:8000)

build-docs:
	$(call docker_run,build --clean)

deploy-image: export DOCKER_USERNAME ?=
deploy-image: export DOCKER_PASSWORD ?=
deploy-image:
	echo $$DOCKER_PASSWORD | docker login -u $$DOCKER_USERNAME --password-stdin
	docker push $(docker_image)
