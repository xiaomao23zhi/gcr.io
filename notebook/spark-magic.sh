#!/bin/bash
################################################################################
# Set sparkmagic config
################################################################################
LIVY_CONF=~/.sparkmagic/config.json

# generate sparkmagic config
function sparkMagicConf() {
    python - <<=EOM
    
import json
import os
with open('~/${LIVY_CONF}.template', 'r') as template_json:
    data = json.loads(template_json.read())
data['kernel_python_credentials']['url']="$livyServer"
data['kernel_scala_credentials']['url']="$livyServer"
data['kernel_r_credentials']['url']="$livyServer"

data['session_configs']={
    'proxyUser': ${JUPYTERHUB_USER}
}
print(json.dumps(data))
=EOM
}

# Main
sparkMagicConf > ${LIVY_CONF}
