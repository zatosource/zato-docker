
.PHONY: build
MAKEFLAGS += --silent

default: echo

ZATO_VERSION=3.2

ZATO_ANSIBLE_DIR=$(CURDIR)/zato-ansible/quickstart
PARENT_IMAGE_DIR=$(CURDIR)/parent
QUICKSTART_IMAGE_DIR=$(CURDIR)/quickstart

parent-build:
	cp $(ZATO_ANSIBLE_DIR)/* $(PARENT_IMAGE_DIR)
	cd $(PARENT_IMAGE_DIR)
	docker build -t zato-$(ZATO_VERSION)-quickstart-parent $(PARENT_IMAGE_DIR)
	cd $(CURDIR)

parent-upload:
	$(MAKE) parent-build
	echo $ZATO_GHCR_TOKEN | docker login ghcr.io -u $ZATO_GHCR_USER --password-stdin
	docker push ghcr.io/zatosource/zato-$(ZATO_VERSION)-quickstart-parent:latest

quickstart-build:
	cp $(ZATO_ANSIBLE_DIR)/* $(QUICKSTART_IMAGE_DIR)
	cd $(QUICKSTART_IMAGE_DIR)
	docker build -t zato-$(ZATO_VERSION)-quickstart $(QUICKSTART_IMAGE_DIR)
	cd $(CURDIR)

quickstart-upload:
	$(MAKE) parent-build
	echo $ZATO_GHCR_TOKEN | docker login ghcr.io -u $ZATO_GHCR_USER --password-stdin
	docker push ghcr.io/zatosource/zato-$(ZATO_VERSION)-quickstart-parent:latest

echo:
	echo Hello from zato-docker
