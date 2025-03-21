#!/usr/bin/env bash
#
# Setup ldap

# Load data in ldap
ldapadd -x -D "cn=admin,dc=example,dc=org" -f ldap_seed.lfid -H ldap://ldap:389 -w admin

# Using a preset Vault Root Token 
vault login root

# Enable ldap auth
vault auth enable ldap

# Login only people in vault group
vault write auth/ldap/config url="${LDAP_ADDR}" \
  bindpass="admin" \
  starttls=false \
  userdn="ou=users,dc=example,dc=org" \
  groupdn="ou=groups,dc=example,dc=org" \
  binddn="cn=admin,dc=example,dc=org" \
  userfilter="(&(objectClass=Person)({{.UserAttr}}={{.Username}})(memberOf=cn=vault,ou=groups,dc=example,dc=org))" ;
  # Success! Data written to: auth/ldap/config

# Add User Policies
vault policy write mng_team_secrets - <<EOF
path "team-secrets/data/" {
    capabilities = ["list", "read", "create", "update", "delete"]
}
path "team-secrets/data/*" {
    capabilities = ["list", "read", "create", "update", "delete"]
}
path "team-secrets/metadata/" {
    capabilities = ["list", "read", "create", "update", "delete"]
}
path "team-secrets/metadata/*" {
    capabilities = ["list", "read", "create", "update", "delete"]
}
EOF


vault policy write dev_secrets - <<EOF
path "team-secrets/data/{{identity.groups.names.dev.id}}/*" {
    capabilities = ["list", "read", "create", "update", "delete"]
}
EOF

vault policy write prod_secrets - <<EOF
path "team-secrets/data/{{identity.groups.names.dev.id}}/*" {
    capabilities = ["list", "read", "create", "update", "delete"]
}
EOF

vault policy write id - <<EOF
path "{{identity.name.id}}" {
    capabilities = ["list", "read", "create", "update", "delete"]
}
EOF

vault write auth/ldap/groups/prod policies=prod_secrets;
vault write auth/ldap/groups/dev policies=dev_secrets;
vault write auth/ldap/groups/vault policies=mng_team_secrets,id,test;


# Get Approle accessor reference
LDAP_ACCESSOR=$(vault auth list -format=json  | jq -r 'to_entries[] | select( .value.type | test( "ldap")) | .value.accessor' )
