FROM ghcr.io/zatosource/zato-3.2-quickstart-parent:latest

# Install prerequisites for Ansible
RUN set -x && \
    apt-get update && \
    apt-get -y install python3 python3-nacl python3-pip libffi-dev sudo

# Install Ansible
RUN pip3 install ansible

# Copy the base Ansible playbook for use inside the container
COPY zato-quickstart.yaml    /zato-ansible/zato-quickstart.yaml
COPY zato-quickstart-01.yaml /zato-ansible/zato-quickstart-01.yaml
COPY zato-quickstart-02.yaml /zato-ansible/zato-quickstart-02.yaml
COPY run-zato-ansible.sh     /zato-ansible/run-zato-ansible.sh

# Make sure that Docker mounts Python requirements as a file
RUN mkdir -p /opt/hot-deploy/python-reqs/ && \
    touch /opt/hot-deploy/python-reqs/requirements.txt && \
    chown -R zato:zato /opt/hot-deploy/

# Signal to Ansible that it should provision a new environment
ENV Zato_Run_Quickstart_Step_02=true

# Dashboard
EXPOSE 8183

# Load-balancer
EXPOSE 11223

# Load-balancer's agent
EXPOSE 20151

# Scheduler
EXPOSE 31530

# Server
EXPOSE 17010

# Run Ansible provisioning when we start up (step 02)
ENTRYPOINT ["/zato-ansible/run-zato-ansible.sh"]
