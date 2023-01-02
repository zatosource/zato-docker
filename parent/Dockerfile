FROM ubuntu:focal

# Install prerequisites for Ansible
RUN apt-get update && apt upgrade -y && \
    apt-get -y install python3 python3-nacl python3-pip libffi-dev sudo

# Install Ansible
RUN pip3 install ansible

# Copy the base Ansible playbook for use inside the container
COPY zato-quickstart.yaml    /zato-ansible/zato-quickstart.yaml
COPY zato-quickstart-01.yaml /zato-ansible/zato-quickstart-01.yaml
COPY zato-quickstart-02.yaml /zato-ansible/zato-quickstart-02.yaml

# Run Ansible provisioning
RUN ansible-playbook -c local -i localhost, /zato-ansible/zato-quickstart.yaml -v \
    --extra-vars '{"Zato_Run_Quickstart_Step_01":true}'

# To make it easy to enter a container
CMD ["/bin/bash"]
