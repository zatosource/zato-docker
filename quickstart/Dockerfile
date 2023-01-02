FROM ghcr.io/zatosource/zato-3.2-quickstart-parent:latest

# Install prerequisites for Ansible
RUN set -x && \
    apt-get update && apt upgrade -y && \
    apt-get -y install python3 python3-nacl python3-pip libffi-dev sudo

# Install Ansible
RUN pip3 install ansible

# Copy the base Ansible playbook for use inside the container
COPY quickstart/test_admin_user.sql    /var/lib/postgresql/scripts/test_admin_user.sql
COPY quickstart/test_odb_tables.sql    /var/lib/postgresql/scripts/test_odb_tables.sql
COPY quickstart/test_odb_cluster.sql    /var/lib/postgresql/scripts/test_odb_cluster.sql
COPY quickstart/test_server_cluster.sql    /var/lib/postgresql/scripts/test_server_cluster.sql
COPY zato-ansible/quickstart/zato-quickstart.yaml    /zato-ansible/zato-quickstart.yaml
COPY zato-ansible/quickstart/zato-quickstart-01.yaml /zato-ansible/zato-quickstart-01.yaml
COPY zato-ansible/quickstart/zato-quickstart-02.yaml /zato-ansible/zato-quickstart-02.yaml
COPY quickstart/run-zato-ansible.sh     /zato-ansible/run-zato-ansible.sh
COPY quickstart/settings.py /opt/settings.py
RUN chown -R zato:zato /opt/settings.py

# Make sure that Docker mounts Python requirements as a file
RUN mkdir -p /opt/hot-deploy/python-reqs/ && \
    touch /opt/hot-deploy/python-reqs/requirements.txt && \
    chown -R zato:zato /opt/hot-deploy/
    

# Signal to Ansible that it should provision a new environment
ENV Zato_Run_Quickstart_Step_02=true

# Run Ansible provisioning when we start up (step 02)
ENTRYPOINT ["/zato-ansible/run-zato-ansible.sh"]
