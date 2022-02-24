#!/bin/bash
ansible-playbook -c local -i localhost, /zato-ansible/zato-quickstart.yaml -v \
    --extra-vars '{"Zato_Run_Quickstart_Step_02":true}' && \
tail -n 500 -f /opt/zato/env/qs-1/server1/logs/server.log
