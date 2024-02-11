.PHONY: build
MAKEFLAGS += --silent

default: echo

ZATO_VERSION=3.2

ZATO_ANSIBLE_DIR=$(CURDIR)/zato-ansible
ZATO_ANSIBLE_QS_DIR=$(ZATO_ANSIBLE_DIR)/quickstart

PARENT_IMAGE_DIR=$(CURDIR)/parent
QUICKSTART_IMAGE_DIR=$(CURDIR)/quickstart

parent-build:
	cp $(ZATO_ANSIBLE_QS_DIR)/* $(PARENT_IMAGE_DIR)
	cd $(PARENT_IMAGE_DIR)
	DOCKER_BUILDKIT=1 docker build --no-cache -t zato-$(ZATO_VERSION)-quickstart-parent $(PARENT_IMAGE_DIR)
	docker tag zato-$(ZATO_VERSION)-quickstart-parent:latest ghcr.io/zatosource/zato-$(ZATO_VERSION)-quickstart-parent:latest
	cd $(CURDIR)

parent-push:
	echo $(ZATO_GHCR_TOKEN) | docker login ghcr.io -u $(ZATO_GHCR_USER) --password-stdin
	docker push ghcr.io/zatosource/zato-$(ZATO_VERSION)-quickstart-parent:latest
	cd $(CURDIR)

parent-all:
	$(MAKE) parent-build
	$(MAKE) parent-push

quickstart-build:
	cp $(ZATO_ANSIBLE_QS_DIR)/* $(QUICKSTART_IMAGE_DIR)
	cd $(QUICKSTART_IMAGE_DIR)
	DOCKER_BUILDKIT=1 docker build --no-cache -t zato-$(ZATO_VERSION)-quickstart $(QUICKSTART_IMAGE_DIR)
	docker tag zato-$(ZATO_VERSION)-quickstart:latest ghcr.io/zatosource/zato-$(ZATO_VERSION)-quickstart:latest
	cd $(CURDIR)

quickstart-push:
	echo $(ZATO_GHCR_TOKEN) | docker login ghcr.io -u $(ZATO_GHCR_USER) --password-stdin
	docker push ghcr.io/zatosource/zato-$(ZATO_VERSION)-quickstart:latest
	cd $(CURDIR)

quickstart-all:
	$(MAKE) quickstart-build
	$(MAKE) quickstart-push

all-build-push:
	~/clean.sh || true
	$(MAKE) parent-all
	$(MAKE) quickstart-all
	$(MAKE) dockerhub-push

dockerhub-push:
	echo $(ZATO_DOCKER_HUB_TOKEN) | docker login -u $(ZATO_DOCKER_HUB_USER) --password-stdin
	docker tag zato-$(ZATO_VERSION)-quickstart zatosource/zato-$(ZATO_VERSION)-quickstart
	docker push zatosource/zato-$(ZATO_VERSION)-quickstart

echo:
	echo Hello from zato-docker
