FROM python

WORKDIR /workdir

RUN apt-get update && apt-get install -y lsb-release software-properties-common ldap-utils

RUN wget -O - https://apt.releases.hashicorp.com/gpg |  gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
RUN echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/hashicorp.list
RUN apt update &&  apt install -y vault jq

# RUN curl -fsSL https://apt.releases.hashicorp.com/gpg | apt-key add -
# RUN apt-add-repository -y "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
# RUN apt-get update && apt-get install -y vault jq

RUN setcap cap_ipc_lock= /usr/bin/vault

# No python yet
# COPY python/requirements.txt .

# RUN pip install -r requirements.txt
# RUN rm requirements.txt

# COPY python/* /usr/local/bin

# Copy shell scripts to setup.
COPY ldap_seed.lfid .
COPY scripts/* /usr/local/bin
# Set command line to wait for login.
CMD exec /bin/bash -c "trap : TERM INT; sleep infinity & wait"

