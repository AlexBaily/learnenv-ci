#!/bin/bash

set -e

git clone https://github.com/AlexBaily/learnenv-infra
cd learnenv-infra
git checkout $BRANCH

cd terraform/environmnets/dev/networking/

terraform init

terraform plan -no-color > $WORKSPACE/output.txt
sed -i '/.*Refresh.*/d' $WORKSPACE/output.txt
#Escape tilde for change in terraform.
sed -i 's/~/\\~/g' $WORKSPACE/output.txt
#Turn white spaces into markdown spaces.
sed -i 's/ /\&nbsp;/g' $WORKSPACE/output.txt
#Add start of JSON response
echo "{\"body\":" > $WORKSPACE/parsed_output.txt
#Turn new lines to line breaks
sed ':a;N;$!ba;s/\n/<br \>/g' $WORKSPACE/output.txt | jq -aRs . >> $WORKSPACE/parsed_output.txt && echo "}" >> $WORKSPACE/parsed_output.txt