.PHONY: build
MAKEFLAGS += --silent

default: echo

Zato_Version=3.2

Zato_Ansible_Dir=$(CURDIR)/zato-ansible
Zato_Ansible_QS_Dir=$(Zato_Ansible_Dir)/quickstart

Parent_Image_Dir=$(CURDIR)/parent
Quickstart_Image_Dir=$(CURDIR)/quickstart

copy-ansible-scripts:
	cp $(Quickstart_Image_Dir)/zato-quickstart.yaml $(Zato_Ansible_QS_Dir)/zato-quickstart.yaml
	cp $(Quickstart_Image_Dir)/zato-quickstart-01.yaml $(Zato_Ansible_QS_Dir)/zato-quickstart-01.yaml
	cp $(Quickstart_Image_Dir)/zato-quickstart-02.yaml $(Zato_Ansible_QS_Dir)/zato-quickstart-02.yaml

parent-build:
	$(MAKE) copy-ansible-scripts
	cp $(Zato_Ansible_QS_Dir)/* $(Parent_Image_Dir)
	cd $(Parent_Image_Dir)
	DOCKER_BUILDKIT=1 docker build --no-cache -t zato-$(Zato_Version)-quickstart-parent $(Parent_Image_Dir)
	docker tag zato-$(Zato_Version)-quickstart-parent:latest ghcr.io/zatosource/zato-$(Zato_Version)-quickstart-parent:latest
	cd $(CURDIR)

parent-push:
	echo $(Zato_GitHub_Token) | docker login ghcr.io -u $(Zato_GitHub_User) --password-stdin
	docker push ghcr.io/zatosource/zato-$(Zato_Version)-quickstart-parent:latest
	cd $(CURDIR)

parent-all:
	$(MAKE) parent-build
	$(MAKE) parent-push

quickstart-build:
	$(MAKE) copy-ansible-scripts
	cp $(Zato_Ansible_QS_Dir)/* $(Quickstart_Image_Dir)
	cd $(Quickstart_Image_Dir)
	DOCKER_BUILDKIT=1 docker build --no-cache -t zato-$(Zato_Version)-quickstart $(Quickstart_Image_Dir)
	docker tag zato-$(Zato_Version)-quickstart:latest ghcr.io/zatosource/zato-$(Zato_Version)-quickstart:latest
	cd $(CURDIR)

dockerhub-push:
	echo $(Zato_DockerHub_Token) | docker login -u $(Zato_DockerHub_User) --password-stdin
	docker tag zato-$(Zato_Version)-quickstart zatosource/zato-$(Zato_Version)-quickstart
	docker push zatosource/zato-$(Zato_Version)-quickstart

github-push:
	echo $(Zato_GitHub_Token) | docker login ghcr.io -u $(Zato_GitHub_User) --password-stdin
	docker push ghcr.io/zatosource/zato-$(Zato_Version)-quickstart:latest
	cd $(CURDIR)

all-build-push:
	~/clean.sh || true
	$(MAKE) parent-all
	$(MAKE) quickstart-build
	$(MAKE) dockerhub-push
	$(MAKE) github-push

echo:
	echo Hello from zato-docker
