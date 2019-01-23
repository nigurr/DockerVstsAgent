#!bin/bash
printf "Cleaning up local folders"
rm -rf ./agent

printf "\n\n\n getting sources \n\n\n"
git clone 'https://github.com/Microsoft/azure-pipelines-agent.git' './agent' --single-branch --branch 'users/nigurr/LogParser_Integration' 

printf "\n\n\n building docker image \n\n\n"
docker build -t agent-parser:v1 .
