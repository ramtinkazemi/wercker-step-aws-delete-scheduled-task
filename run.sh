#!/bin/bash
set +e
set -o noglob

#
# Headers and Logging
#

error() { printf "✖ %s\n" "$@"
}
warn() { printf "➜ %s\n" "$@"
}

type_exists() {
  if [ $(type -P $1) ]; then
    return 0
  fi
  return 1
}

STEP_PREFIX="WERCKER_AWS_ECS_DELETE_SCHEDULED_TASK"
step_var() {
  echo $(tmp=${STEP_PREFIX}_$1 && echo ${!tmp}) 
}


# Check python is installed
if ! type_exists 'python3'; then
  error "Please install python 3.x"
  exit 1
fi

# Check pip is installed
if ! type_exists 'pip'; then
  error "Please install pip"
  exit 1
fi

# Check env file
# https://github.com/builtinnya/dotenv-shell-loader
# source $WERCKER_STEP_ROOT/src/dotenv-shell-loader.sh
# dotenv

# Check variables
if [ -z "$(step_var 'KEY')" ]; then
  error "Please set the 'key' variable"
  exit 1
fi

if [ -z "$(step_var 'SECRET')" ]; then
  error "Please set the 'secret' variable"
  exit 1
fi

if [ -z "$(step_var 'REGION')" ]; then
  error "Please set the 'region' variable"
  exit 1
fi

echo "HERE 1"

if [ -z "$(step_var 'SCHEDULE_RULE_NAME')" ]; then
  error "Please set the 'schedule-rule-name' variable"
  exit 1
fi

if [ -z "$(step_var 'TARGET_ID')" ]; then
  error "Please set the 'target-id' variable"
  exit 1
fi

# INPUT Variables for main.sh

#FOR AWS CONFIGURE
STEP_AWS_ACCESS_KEY_ID=$(step_var 'KEY')
STEP_AWS_SECRET_ACCESS_KEY=$(step_var 'SECRET')
STEP_AWS_DEFAULT_REGION=$(step_var 'REGION')

#FOR AWS EVENT RULE
STEP_SCHEDULE_RULE_NAME=$(step_var 'SCHEDULE_RULE_NAME')

#FOR AWS EVENT TARGET
STEP_TARGET_ID=$(step_var 'TARGET_ID')

STEP_DIR=$WERCKER_STEP_ROOT

source $STEP_DIR/src/main.sh





