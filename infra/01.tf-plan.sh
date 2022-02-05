#!/bin/bash

SCRIPT_ERR=0

git clone https://github.com/AlexBaily/learnenv-infra
cd learnenv-infra
git checkout $BRANCH

cd terraform/environmnets/dev/networking/

terraform init -no-color &> $WORKSPACE/output.txt

#Check to make sure init ran before trying to run the plan.
if [ $? == 0 ]; then
    terraform plan -no-color &> $WORKSPACE/output.txt
    if [ $? != 0 ]; then
        SCRIPT_ERR=1
    fi
    sed -i '/.*Refresh.*/d' $WORKSPACE/output.txt
else
    SCRIPT_ERR=1
fi

#Escape tilde for change in terraform.
sed -i 's/~/\\~/g' $WORKSPACE/output.txt
#Turn white spaces into markdown spaces.
sed -i 's/ /\&nbsp;/g' $WORKSPACE/output.txt
#Add start of JSON response
echo "{\"body\":" > $WORKSPACE/parsed_output.txt
#Turn new lines to line breaks then parse to JSON using JQ.
sed ':a;N;$!ba;s/\n/<br \>/g' $WORKSPACE/output.txt | jq -aRs . >> $WORKSPACE/parsed_output.txt && echo "}" >> $WORKSPACE/parsed_output.txt

curl -H "Authorization: token $GITHUB_TOKEN" "https://api.GitHub.com/repos/AlexBaily/learnenv-infra/issues/$pr_num/comments" -H "Accept: application/vnd.github.VERSION.text+json" -X POST -d "@$WORKSPACE/parsed_output.txt"

if [ SCRIPT_ERR != 0 ]; then
    exit 1
fi