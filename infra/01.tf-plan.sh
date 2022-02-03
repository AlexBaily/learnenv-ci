#!/bin/bash

set -e

git clone https://github.com/AlexBaily/learnenv-infra
cd learnenv-infra
git checkout $BRANCH

cd terraform/environmnets/dev/networking/

terraform init

terraform plan > $WORKDIR/output.txt
sed -i '/.*Refresh.*/d' $WORKDIR/output.tf

return 