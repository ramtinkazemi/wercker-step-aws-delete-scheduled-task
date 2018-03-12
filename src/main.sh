#!/bin/sh

###################################
# INPUT
#
# echo $STEP_AWS_PROFILE
# echo $STEP_AWS_ACCESS_KEY_ID
# echo $STEP_AWS_SECRET_ACCESS_KEY
# echo $STEP_AWS_DEFAULT_REGION
# 
# echo $STEP_SCHEDULE_RULE_NAME
# echo $STEP_TARGET_ID

STEP_AWS_PROFILE=wercker-step-aws-ecs

aws configure set aws_access_key_id ${STEP_AWS_ACCESS_KEY_ID} --profile ${STEP_AWS_PROFILE}
aws configure set aws_secret_access_key ${STEP_AWS_SECRET_ACCESS_KEY} --profile ${STEP_AWS_PROFILE}
if [ -n "${STEP_AWS_DEFAULT_REGION}" ]; then
  aws configure set region ${STEP_AWS_DEFAULT_REGION} --profile ${STEP_AWS_PROFILE}
fi

warn "Collection Input Data for Target template"
#TASK_DEFINITION_ARN=$(aws ecs describe-task-definition --profile ${STEP_AWS_PROFILE} --task-definition ${STEP_TASK_DEFINITION} --query taskDefinition.taskDefinitionArn --output text)
_AWS_ACCOUNT=$(aws sts get-caller-identity --profile ${STEP_AWS_PROFILE} --output text --query 'Account')
ROLE_ARN=arn:aws:iam::${_AWS_ACCOUNT}:role/ecsEventsRole
#CLUSTER_ARN=$(aws ecs describe-clusters --profile ${STEP_AWS_PROFILE} --clusters ${STEP_CLUSTER} --query clusters[0].clusterArn --output text)

warn "Remove target : ${STEP_TARGET_ID}"
aws events remove-targets \
    --profile ${STEP_AWS_PROFILE} \
    --rule "${STEP_SCHEDULE_RULE_NAME}" \
    --ids "${STEP_TARGET_ID}" 


warn "Delete rule: ${STEP_SCHEDULE_RULE_NAME}"
aws events delete-rule \
    --profile ${STEP_AWS_PROFILE} \
    --name "${STEP_SCHEDULE_RULE_NAME}" 

