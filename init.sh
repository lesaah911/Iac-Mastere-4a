#!/usr/bin/bash

set -eu -o pipefail

if [ ! -d ".git" ]; then
    git init
fi

{
        echo "*.tfvars"
        echo ".env"
        echo "terraform"
        echo "*.tfstate"
        echo "*tfstate*"
        echo "tfplan"
        echo "*tfplan*"

}>> .gitignore

mkdir -p infra/envs/dev
cd infra/envs/dev
touch main.tf variables.tf versions.tf \
outputs.tf providers.tf dev.aut.tfvars

mkdir -p infra/modules/compute
mkdir -p infra/modules/security_group

rm  make

for f in infra/modules/compute infra/modules/security_group; do
    touch main.tf variables.tf versions.tf outputs.tf
done

