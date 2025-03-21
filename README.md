# Vault integration env with Approle templates.

In this case, we are using the Approle entity metadata as the link to utilise a single policy for all AppRoles. This simplifies the creation of new Application that follow the same secrets storage policy. 

# Startup 

To start, launch docker compose. 

    docker compose up -d --build

Our docker composes uses Hashicorp's vault container. It is started up with the root key as "root" to simplify the initial setup. Currently We use root for the initial setup of the systems. After that, we create userpass users and add what is required as needed.

## Initial provisioning 

The shell container has the initial provisioning scripts. : 

    docker compose exec shell /bin/bash -c setup-vault.sh

You can then run a simple test script to make sure evrything is ok - it sohuld give one error at the end when reading data it does not have permission to read..

    docker compose exec shell /bin/bash -c test-setup.sh

If you ever need to re-run the vault setup, you should run the reset-vault.sh script first or errors will occure for already existing systems.

    docker compose exec shell /bin/bash -c reset-vault.sh

## Notes:

- The UI is accessible from localhost:8200
- If you have vault setup, the scripts can be run from a local command shell as well. The Shell docker image, is just for convenience as everything is already setup.
- The Docker image for Vault is the  official hashicorp image.

