#!/usr/bin/env bash
#

for x in {1..6} ; do
  echo "===> Logging in as user${x}" ;
  vault login -method=ldap username=user${x} password=user${x} ;
  vault read -format=json sys/internal/ui/resultant-acl | jq -r '..data.glob_paths' ;

done
