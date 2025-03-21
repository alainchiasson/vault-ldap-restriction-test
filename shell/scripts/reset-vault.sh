#!/usr/bin/env bash
#

# Using a preset Vault Root Token 
vault login root

vault auth disable approle
vault auth disable userpass
vault secrets disable team-secrets

