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
EXPOSE 8184
EXPOSE 8185
EXPOSE 8186
EXPOSE 8187

# Load-balancer
EXPOSE 11223
EXPOSE 11224
EXPOSE 11225
EXPOSE 11226
EXPOSE 11227

# Load-balancer's agent
EXPOSE 20151
EXPOSE 20152
EXPOSE 20153
EXPOSE 20154
EXPOSE 20155

# Scheduler
EXPOSE 31530
EXPOSE 31531
EXPOSE 31532
EXPOSE 31533
EXPOSE 31534

# Server
EXPOSE 17010
EXPOSE 17011
EXPOSE 17012
EXPOSE 17013
EXPOSE 17014

# Run Ansible provisioning when we start up (step 02)
ENTRYPOINT ["/zato-ansible/run-zato-ansible.sh"]
