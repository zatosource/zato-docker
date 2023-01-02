#!/bin/bash

/opt/zato/current/bin/py << IN_PYTHON
# stdlib
import os
from json import dumps

# The list of environment variables that we recognize
# and that can be passed to the underlying Ansible playbook.
env_keys = [
    'Zato_SSH_Password',
    'Zato_Dashboard_Password',
    'Zato_IDE_Password',
    'Zato_Python_Reqs',
    'Zato_Hot_Deploy_Dir',
    'Zato_User_Conf_Dir',
    'Zato_Extlib_Dir',
    'Zato_Enmasse_File',
    'Zato_Cluster_Name',
    'Zato_ODB_Type',
    'Zato_ODB_Hostname',
    'Zato_ODB_Port',
    'Zato_ODB_Name',
    'Zato_ODB_Username',
    'Zato_ODB_Password',
    'Zato_IP_Address',
    'Zato_Host_Dashboard_Port',
    'Zato_Host_Server_Port',
    'Zato_Host_Server_Num',
    'Zato_Host_Server_Name',
    'Zato_Host_Server_Wait',
    'Zato_Host_Scheduler_Host',
    'Zato_Host_Scheduler_Port',
    'Zato_Secret_Key',
    'Zato_Jwt_Secret',
    'Zato_Host_LB_Host',
    'Zato_Host_LB_Port',
    'Zato_Host_LB_Agent_Port',
    'Zato_Host_Database_Port',
    'Zato_Host_SSH_Port',
    'Zato_Run_Internal_Tests',
    'Zato_Run_Quickstart_Step_01',
    'Zato_Run_Quickstart_Step_02',
    'Zato_Dashboard_Debug',
    'Zato_Crsf_Trusted_Origins',
    'Zato_Run_Spark'
]

# Build a mapping of environment values that were provided on input
env_values = {}

for name in env_keys:
    value = os.environ.get(name) or None
    env_values[name] = value

# For backward compatibility, map the following keys to the current ones.
# Note that the current keys have priority in case both are specified.
env_keys_prev = {
    'ODB_TYPE':     'Zato_ODB_Type',
    'ODB_HOSTNAME': 'Zato_ODB_Hostname',
    'ODB_PORT':     'Zato_ODB_Port',
    'ODB_NAME':     'Zato_ODB_Name',
    'ODB_USERNAME': 'Zato_ODB_Username',
    'ODB_PASSWORD': 'Zato_ODB_Password',

    'ZATO_SSH_PASSWORD':           'Zato_SSH_Password',
    'ZATO_WEB_ADMIN_PASSWORD':     'Zato_Dashboard_Password',
    'ZATO_IDE_PUBLISHER_PASSWORD': 'Zato_IDE_Password',
    'ZATO_ENMASSE_FILE':           'Zato_Enmasse_File',
}

for prev_name, current_name in env_keys_prev.items():
    current_value = env_values.get(current_name)
    if not current_value:
        prev_value = os.environ.get(prev_name) or None
        if prev_value:
            env_values[current_name] = prev_value

#
# These two previous keys used to be supported but they are not anymore
# REDIS_HOSTNAME
# ZATO_ENMASSE_INITIAL_SLEEP
#

# Optionally, make Ansible output in a verbose mode
build_verbosity = os.environ.get('Zato_Build_Verbosity') or ''

# Turn the dictionary of parameters into a JSON document expected by Ansible.
env_values = dumps(env_values)

# Build a list of Ansible parameters to invoke via sh
cli_params = []
cli_params.append('ansible-playbook')
cli_params.append('-c')
cli_params.append('local')
cli_params.append('-i')
cli_params.append('localhost,')
cli_params.append('/zato-ansible/zato-quickstart.yaml')
cli_params.append(build_verbosity)
cli_params.append('--extra-vars')
cli_params.append(f"'{env_values}'")
cli_params.append('&&')
cli_params.append('tail')
cli_params.append('-n')
cli_params.append('500')
cli_params.append('-f')
cli_params.append('/opt/zato/env/qs-1/server1/logs/server.log')

# Build a full command
command = ' '.join(cli_params)

# And write it to a file that will be invoked
f = open('/zato-ansible/run-zato-ansible-impl.sh', 'w')
f.write('#!/bin/bash')
f.write('\n')
f.write(command)
f.write('\n')
f.close()

IN_PYTHON

# Run the commands now
bash /zato-ansible/run-zato-ansible-impl.sh
