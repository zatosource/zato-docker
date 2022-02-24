
.PHONY: build
MAKEFLAGS += --silent

default: echo

ZATO_VERSION=3.2

PARENT_IMAGE_DIR=$(CURDIR)/parent
ZATO_ANSIBLE_DIR=$(CURDIR)/../zato-ansible/quickstart

parent-build:
	cp $(ZATO_ANSIBLE_DIR)/* $(PARENT_IMAGE_DIR)
	cd $(PARENT_IMAGE_DIR)
	docker build -t zato-$(ZATO_VERSION)-quickstart-parent $(PARENT_IMAGE_DIR)
	cd $(CURDIR)

echo:
	echo Hello from zato-docker
	# $(MAKE) install-qa-reqs
