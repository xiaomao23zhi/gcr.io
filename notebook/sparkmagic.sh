#!/bin/bash
################################################################################
# Set sparkmagic config
################################################################################
livyConf=~/.sparkmagic/config.json
livyServer=${LIVY_SERVER:-"localhost:8998"}

# generate sparkmagic config
function sparkMagicConf() {
    python - <<=EOM
    
import json
import os
with open('${LIVY_CONF}.template', 'r') as template_json:
    data = json.loads(template_json.read())
data['kernel_python_credentials']['url']="$livyServer"
data['kernel_scala_credentials']['url']="$livyServer"
data['kernel_r_credentials']['url']="$livyServer"

data['session_configs']['proxyUser']="$JUPYTERHUB_USER"

print(json.dumps(data))
=EOM
}

# Main
sparkMagicConf > $livyConf
