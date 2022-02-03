#!/bin/bash

set -e

git clone https://github.com/AlexBaily/learnenv-infra
cd learnenv-infra
git checkout $BRANCH

cd terraform/environmnets/dev/networking/

terraform init

terraform plan > $WORKSPACE/output.txt
sed -i '/.*Refresh.*/d' $WORKSPACE/output.txt

return 